#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd dist

# git init, add and commit all files in dist, then push to gh-pages of repo
git init
git add -A
git commit -m 'deploy'
git push -f git@github.com:dengsauve/circuit-workout-timer.git master:gh-pages
cd -
