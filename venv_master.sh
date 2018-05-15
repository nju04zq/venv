#!/bin/bash

source util.sh

OS=$(uname)
if [ ${OS} = "Darwin" ]; then
    # brew install coreutils
    readlink="greadlink"
elif [ ${OS} = "Linux" ]; then
    readlink="readlink"
else
    echo "Not support OS ${OS}!"
    exit 1
fi
SCRIPT=$(${readlink} -f $0)
SCRIPT_NAME=$(basename ${SCRIPT})
WORKDIR=$(dirname ${SCRIPT})

md5_api() # usage, md5api $file
{
    if [ ${OS} = "Darwin" ]; then
        md5 -q $1
    elif [ ${OS} = "Linux" ]; then
        md5sum $1 | awk '{print $1}'
    else
        echo "Not support OS ${OS}!"
        exit 1
    fi
}

DOWNLOAD_PYTHON_URL="https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz"
DOWNLOAD_PYTHON_TGZ="Python-2.7.13.tgz"
PYTHON2713_MD5="17add4bf0ad0ec2f08e0cae6d205c700"

if [ ! -f ${DOWNLOAD_PYTHON_TGZ} ] || [ $(md5_api ${DOWNLOAD_PYTHON_TGZ}) != ${PYTHON2713_MD5} ]; then
    progress "Download python 2.7.13"
    run_cmd wget ${DOWNLOAD_PYTHON_URL}
fi

progress "Build docker image"
run_cmd docker build . -t venv:v0

progress "Make venv package inside docker"
run_cmd docker run --rm -v ${WORKDIR}:/storage:rw -w /storage venv:v0 /bin/bash make_venv.sh
