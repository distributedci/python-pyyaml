#!/bin/bash
pkg=python-pyyaml
set -eux
if [ $# != 2 ]; then
    echo "Usage: $0 <tag> <First last email>" 1>&2
    exit 1
fi
tag="$1"
email="$2"
date="$(env LANG=C date '+%a %b %d %Y')"
git remote add github git@github.com:yaml/pyyaml.git || :
git fetch github
git checkout -b import-"$tag" || git checkout import-"$tag"
git archive --format=tar "$tag" | tar xv --exclude .github
git add .
sed -i -e "s/\(Version:\s*\).*/\1$tag/" -e "s/\(Release:\s*\)[0-9]\{1,\}/\11/" -e "s/%changelog/%changelog\n* $date $email $tag-1\n- New Upstream release\n/" $pkg.spec
git commit -m "imported release $tag" -a
# import-release.sh ends here
