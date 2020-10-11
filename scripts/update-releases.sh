#!/bin/bash
##
# @license MPL-2.0
# @author William Desportes <williamdes@wdes.fr>
##

set -e


echo 'Fetch ...'
#git fetch --all -p -P

MAJOR_RELEASES=$(jq -r '.[] | "\(.major).\(.minor)"' releases.json)

for majorMinor in $(echo -e ${MAJOR_RELEASES}); do
echo 'Detected series:'
echo "- ${majorMinor}"

GET_RELEASES="\"\(.major).\(.minor)\"==\"${majorMinor}\""

VERSIONS=$(jq -r ".[] | select(${GET_RELEASES})" releases.json | jq -c -r '.versions | .[]')

echo 'Detected versions:'
for version in $(echo -e ${VERSIONS}); do
	PATCH=$(jq '.patch' <<< "${version}")
	echo "- ${majorMinor}.${PATCH}"
done

done
