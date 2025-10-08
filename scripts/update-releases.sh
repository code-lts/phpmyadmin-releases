#!/bin/bash
##
# @license MPL-2.0
# @author William Desportes <williamdes@wdes.fr>
##

set -e

# -- Functions -- #

checkBinary () {
	if ! command -v ${1} &> /dev/null
	then
		quitError "${1} could not be found"
	fi
}

quitError () {
	echo -e "\033[0;31m[ERROR] ${1}\033[0m" >&2
	exit ${2:-1}
}

logDebug () {
	echo -e "\033[1;35m[DEBUG] ${1}\033[0m" >&2
}

logInfo () {
	echo -e "\033[1;35m[INFO] ${1}\033[0m" >&2
}

checkRepoInGoodState () {
	if [ ! -d ./build ]; then
		quitError 'Please create a directory named build at the repository root.'
	fi
	if output=$(git status --porcelain) && [ ! -z "$output" ]; then
		quitError 'Some changes are not committed, please clean your repository first.'
	fi
	logDebug "Showing non pushed tags"
	git fetch --prune-tags --dry-run
	logDebug "Fetch and prune branches"
	git fetch --prune
}

checkBinaries () {
	checkBinary 'jq'
	checkBinary 'curl'
}

getReleaseName () {
   jq -r '.name' <<< "${1}"
}

getMajorReleases () {
	jq -r '.[] | "\(.major).\(.minor)"' releases.json
}

getMinorForMajorMinor () {
	jq -r ".[] | select(\"\(.major).\(.minor)\"==\"${1}\") | .minor" releases.json
}

getMajorForMajorMinor () {
	jq -r ".[] | select(\"\(.major).\(.minor)\"==\"${1}\") | .major" releases.json
}

getImported () {
	jq -r '.imported' <<< "${1}"
}

getReleasesForMajorMinor () {
	GET_RELEASES="\"\(.major).\(.minor)\"==\"${1}\""
	jq -r ".[] | select(${GET_RELEASES})" releases.json | jq -c -r '.versions | .[]'
}

setVersionImported () {
	MAJOR_MINOR="${1}"
	RELEASE_NAME="$(getReleaseName "${2}")"
	jq --monochrome-output --tab "(.[] | select(\"\(.major).\(.minor)\"==\"${MAJOR_MINOR}\") | .versions[] | select(.name==\"${RELEASE_NAME}\") | .imported) = true" <<< $(cat releases.json) 1> releases.json
	git add releases.json
	git commit -m "Set ${RELEASE_NAME} as imported"
}

downloadReleaseFile () {
	RELEASE_NAME="${1}"
	RELEASE_VARIANT="${2}"
	cd ./build/
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz ]; then
		logDebug "Downloading phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz"
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz
	fi
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.asc ]; then
		logDebug "Downloading phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.asc"
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.asc
	fi
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.sha256 ]; then
		logDebug "Downloading phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.sha256"
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.sha256
	fi
	cd - > /dev/null
}

checkReleaseFile () {
	BUNDLE_FILE="${1}"
	logDebug "Checking ${BUNDLE_FILE}"
	cd ./build/
	sha256sum --check --strict "${BUNDLE_FILE}.sha256"
	gpg --verify "${BUNDLE_FILE}.asc"
	cd - > /dev/null
}

doImportOfVersionToCommit () {
	RELEASE_NAME="$(getReleaseName "${1}")"
	MAJOR="$(getMajorForMajorMinor "${2}")"
	MINOR="$(getMinorForMajorMinor "${2}")"
	logInfo "Importing ${RELEASE_NAME} ..."
	variantList=('all-languages' 'english' 'source')
	for variant in "${variantList[@]}"; do
		branchName="upstream/series/latest-${variant}/${MAJOR}-${MINOR}"
		# Sync with commitVersion
		tagName="upstream/version/${variant}/${RELEASE_NAME}"
		if [ "$(git tag -l "$tagName")" == "$tagName" ]; then
			logInfo "The release ${tagName} is already imported"
			continue
		fi
		downloadReleaseFile "${RELEASE_NAME}" ${variant}
		checkReleaseFile "phpMyAdmin-${RELEASE_NAME}-${variant}.tar.xz" # The function will cd into build
		bundleToCommitOnBranch \
			"./build/phpMyAdmin-${RELEASE_NAME}-${variant}.tar.xz" \
			"phpMyAdmin-${RELEASE_NAME}-${variant}" \
			"$branchName" \
			"${variant}" \
			"${RELEASE_NAME}"
	done
}

addArchiveFilesToGit () {
	BUNDLE_FILE="${1}"
	BUNDLE_NAME="${2}" # Used to emulate a strip-components on each file name
	FILES_TO_ADD=()
	for file in $(tar --list --file="${BUNDLE_FILE}"); do
		RELATIVE_PATH=${file/${BUNDLE_NAME}\//}
		if [ -f "${RELATIVE_PATH}" ]; then
			FILES_TO_ADD+=(${RELATIVE_PATH})
		fi
	done
	# Add all files
	git add "${FILES_TO_ADD[@]}"
}

cleanGitFiles () {
	logDebug 'Removing all files tracked by GIT'
	FILES_TO_DELETE=$(git ls-files)
	if [ ! -z "${FILES_TO_DELETE}" ]; then
		git rm --quiet ${FILES_TO_DELETE}
	fi
}

commitVersion () {
	VERSION_NAME="${1}"
	VARIANT="${2}"
	git commit --quiet -S -m "Added new version: ${VERSION_NAME}"
	git tag -a -s -m "version: ${VERSION_NAME}" "upstream/version/${VARIANT}/${VERSION_NAME}"
}

bundleToCommitOnBranch () {
	BUNDLE_FILE="${1}"
	BUNDLE_NAME="${2}"
	BRANCH="${3}"
	VARIANT="${4}"
	VERSION_NAME="${5}"
	logDebug "Importing bundle ${BUNDLE_FILE}"
	if [ ! -f "${BUNDLE_FILE}" ]; then
		quitError "The bundle file ${BUNDLE_FILE} does not exist."
	fi
	logDebug "Check branch exists for 'refs/heads/${BRANCH}'"
	REF_EXISTS=$(git show-ref --quiet "refs/heads/${BRANCH}" && echo $? || echo $?)
	if [ "${REF_EXISTS}" != "0" ]; then
		logDebug "Branch ${BRANCH} does not exist, creating."
		git checkout --quiet -b "${BRANCH}" upstream/origin
		git checkout --quiet -
	fi
	logDebug "checkout ${BRANCH}"
	git checkout --quiet "${BRANCH}"
	cleanGitFiles
	logDebug "Extracting bundle ${BUNDLE_FILE}"
	tar -xJf "${BUNDLE_FILE}" --strip-components=1
	logDebug "Add files from bundle ${BUNDLE_FILE} to git"
	addArchiveFilesToGit "${BUNDLE_FILE}" "${BUNDLE_NAME}"
	logDebug "Commit files from bundle ${BUNDLE_FILE} to git"
	commitVersion "${VERSION_NAME}" "${VARIANT}"
	git checkout --quiet -
	logDebug "All done for bundle ${BUNDLE_FILE}"
}

# -- Init -- #

checkBinaries

checkRepoInGoodState

for majorMinor in $(getMajorReleases); do
logInfo 'Detected series:'
logInfo "- ${majorMinor}"

	logInfo 'Detected versions:'
	for version in $(getReleasesForMajorMinor ${majorMinor}); do
		logInfo "- $(getReleaseName "${version}")"
	done

	logInfo 'Importing...'
	for version in $(getReleasesForMajorMinor ${majorMinor}); do
		if [ $(getImported "${version}") == "false" ]; then
			logDebug "Not imported: $(getReleaseName "${version}")"
			doImportOfVersionToCommit "${version}" "${majorMinor}"
			setVersionImported "${majorMinor}" "${version}"
		fi
	done
done
