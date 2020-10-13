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
		echo "${1} could not be found"
		exit
	fi
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

getReleasesForMajorMinor () {
	GET_RELEASES="\"\(.major).\(.minor)\"==\"${1}\""
	jq -r ".[] | select(${GET_RELEASES})" releases.json | jq -c -r '.versions | .[]'
}

downloadReleaseFile () {
	RELEASE_NAME="${1}"
	RELEASE_VARIANT="${2}"
	cd ./build/
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz ]; then
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz
	fi
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.asc ]; then
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.asc
	fi
	if [ ! -f phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.sha256 ]; then
		curl -# -O https://files.phpmyadmin.net/phpMyAdmin/${RELEASE_NAME}/phpMyAdmin-${RELEASE_NAME}-${RELEASE_VARIANT}.tar.xz.sha256
	fi
	cd - > /dev/null
}

doImportOfVersionToCommit () {
	RELEASE_NAME="$(getReleaseName "${version}")"
	echo "Importing ${RELEASE_NAME} ..."
	downloadReleaseFile "${RELEASE_NAME}" 'all-languages'
	downloadReleaseFile "${RELEASE_NAME}" 'english'
	downloadReleaseFile "${RELEASE_NAME}" 'source'
}

# -- Init -- #

checkBinaries

echo 'Fetch ...'
#git fetch --all -p -P

for majorMinor in $(getMajorReleases); do
echo 'Detected series:'
echo "- ${majorMinor}"

	echo 'Detected versions:'
	for version in $(getReleasesForMajorMinor ${majorMinor}); do
		echo "- $(getReleaseName "${version}")"
	done

	echo 'Importing...'
	for version in $(getReleasesForMajorMinor ${majorMinor}); do
		doImportOfVersionToCommit "${version}"
	done
done
