#!/bin/bash

FG_WHITE_BG_BLACK="\033[37;40m"
FG_BLUE_BG_BLACK="\033[34;40m"
FG_RED_BG_BLACK="\033[31;40m"
FG_CYAN_BG_BLACK="\033[36;40m"
COLORS_ALL_OFF="\033[0m"

err() # usage, err_msg msg
{
    echo -e ${FG_RED_BG_BLACK}$@${COLORS_ALL_OFF}
}

info() # usage, err_msg msg
{
    msg="### "$@" ###"
    echo -e ${FG_CYAN_BG_BLACK}${msg}${COLORS_ALL_OFF}
}

progress() #usage, progress msg
{
    msg="=== "$@" ==="
    echo -e ${FG_WHITE_BG_BLACK}${msg}${COLORS_ALL_OFF}
}

# Tips:
# 1. If param has output redirector like >&, wrap the whole cmdline in quotes
# 2. If param has pipe |, wrap the whole cmdline in quotes
run_cmd() #usage, run_cmd cmd xxx
{
    cmd="$@"
    msg="Running cmd: "${cmd}
    echo -e ${FG_BLUE_BG_BLACK}${msg}${COLORS_ALL_OFF}
    eval ${cmd}
}

