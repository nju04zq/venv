#!/bin/bash

set -e

source util.sh
source pymodules.sh

USER="user"
VENV_PATH="/home/${USER}/.venv"
VENV_TGZ_NAME="venv.tgz"
VENV_TGZ_TMP="/tmp/${VENV_TGZ_NAME}"
VENV_TGZ="/storage/${VENV_TGZ_NAME}"

export PATH=${VENV_PATH}/bin:$PATH

SCRIPT=$(readlink -f $0)
SCRIPT_NAME=$(basename ${SCRIPT})
WORKDIR=$(dirname ${SCRIPT})

PIP_OPTION="-i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/"

run_script_as_user() # usage, run_as_root keyword
{
    info "Run as role ${USER}!"
    tmpscript="/tmp/"${SCRIPT_NAME}$$$(date +%s)
    tmputil="/tmp/util.sh"
    run_cmd cp ${SCRIPT} ${tmpscript}
    run_cmd cp ${WORKDIR}/util.sh ${tmputil}
    run_cmd chmod a+x ${tmpscript}
    su ${USER} -c "${tmpscript}"
    run_cmd rm ${tmpscript}
    run_cmd rm ${tmputil}
    info "Exit role ${USER}!"
}

create_user_account() # usage, create_user_account
{
    progress "Create account for ${USER}"
    run_cmd useradd ${USER}
    run_cmd 'echo -ne "${USER}\n${USER}\n" | passwd ${USER}'
}

copy_venv_tgz() # usage, copy_venv_tgz
{
    progress "Copy ${VENV_TGZ_NAME}"
    run_cmd mv ${VENV_TGZ_TMP} ${VENV_TGZ}
}

prepare_python_files() # usage, copy_python_files
{
    progress "Prepare python files"
    run_cmd mkdir -p ${VENV_PATH}/bin ${VENV_PATH}/lib ${VENV_PATH}/include
    run_cmd 'echo "export PATH=${VENV_PATH}/bin:\$PATH" >> ${VENV_PATH}/bin/activate'
    run_cmd cp /usr/bin/python2.7 ${VENV_PATH}/bin/python
    run_cmd cp -r /usr/include/python2.7 ${VENV_PATH}/include/
    run_cmd cp -r /usr/lib/python2.7 ${VENV_PATH}/lib
    run_cmd 'curl https://bootstrap.pypa.io/get-pip.py | python -'
    run_cmd pip install ${PY_MODULES} ${PIP_OPTION}
    run_cmd 'find ${VENV_PATH} \( -name "*.pyc" -or -name "*.pyo" \) -exec rm {} \;'
}

make_venv_tgz() # usage, make_venv_tgz
{
    progress "Make ${VENV_TGZ_NAME}"
    run_cmd tar zcfP ${VENV_TGZ_TMP} ${VENV_PATH}
}

if [ $(whoami) = "root" ]; then
    create_user_account
    run_script_as_user
    copy_venv_tgz
fi

if [ $(whoami) = "${USER}" ]; then
    prepare_python_files
    make_venv_tgz
fi
