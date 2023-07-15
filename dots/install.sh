#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# script working directory
BASEDIR=$(cd "$(dirname "$0")" ; pwd -P)

GIT_CWD=$(git -C ${BASEDIR} rev-parse --show-toplevel)
GIT_CMD="git -C ${GIT_CWD}"
DOT_CMD="git -c status.showUntrackedFiles=no --git-dir=${GIT_CWD}/.git -C ${HOME}"
REPO_URL=$(${GIT_CMD} config --get remote.origin.url)

# pull latest
echo "[1;32mPulling[0m from [0;33m${REPO_URL}[1;32m...[0m"
${GIT_CMD} pull --ff-only --progress --rebase=true

# reset to local HEAD
echo "[1;32mResetting to [0;33mHEAD[1;32m...[0m"
${DOT_CMD} reset --hard HEAD

# configure repo to not display untracked files
echo "[1;32mConfiguring repo[0m [0;33mstatus.showUntrackedFiles=no[0m"
${GIT_CMD} config --local status.showUntrackedFiles no

# setup repo symbolic link at $HOME
echo "[1;32mSetup repo link [0m [0;33m$HOME/.git[0m -> [0;33m$GIT_CWD/.git[0m"
ln -fs ${GIT_CWD}/.git ${HOME}/.git

# Source aliases
alias dot="${DOT_CMD}"
echo "[1;32mCreated the [0;33mdot[1;32m alias.[0m"