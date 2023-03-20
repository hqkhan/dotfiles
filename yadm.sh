#!/bin/sh -e
set -eu
trap 'echo "EXIT detected with exit status $?"' EXIT

# script working directory
BASEDIR=$(cd "$(dirname "$0")" ; pwd -P)

YADM_PROJ=${BASEDIR}/yadm-project
YADM_REPO=${BASEDIR}/yadm-repo
YADM_BIN=${YADM_PROJ}/yadm
YADM_CMD="${YADM_BIN} --yadm-repo ${YADM_REPO}"
YADM_GIT="git@github.com:hqkhan/yadm-config.git"
SSH_KEY="$HOME/.ssh/id_rsa_github"
GIT_SSH_COMMAND="ssh -i ${SSH_KEY} -o IdentitiesOnly=yes"

if [ ! -e ${SSH_KEY} ]; then
    echo "Unable to locate repo SSH key in '${SSH_KEY}', aborting."
    exit 1
fi

# clone the yadm project source (clone)
git clone https://github.com/TheLocehiliosan/yadm.git ${YADM_PROJ}
# ln -s ${YADM_BIN} $HOME/bin/yadm

# clone the yadm-repo (the actual dotfiles)
if [ ! -e ${YADM_REPO} ]; then
    echo "Cloning ${YADM_REPO}"
    GIT_SSH_COMMAND=${GIT_SSH_COMMAND} ${YADM_CMD} \
        clone ${YADM_GIT}
else
    echo "Pulling from ${YADM_GIT}"
    GIT_SSH_COMMAND=${GIT_SSH_COMMAND} ${YADM_CMD} \
        pull --ff-only --progress --rebase=true
fi

# reset to local HEAD
echo "[1;32mResetting to HEAD...[0m"
${YADM_CMD} reset --hard HEAD

# update submodules
echo "[1;32mUpdating submodules...[0m"
${YADM_CMD} submodule update --init --recursive

echo "[1;32mDONE.[0m"
