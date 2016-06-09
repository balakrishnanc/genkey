#!/usr/bin/env bash
# -*- mode: sh; coding: utf-8; fill-column: 80; -*-
#
# genkey.sh
# Created by Balakrishnan Chandrasekaran on 2016-05-20 15:57 -0400.
# Copyright (c) 2016 Balakrishnan Chandrasekaran <balakrishnan.c@gmail.com>.
#

readonly SSH_KGEN='/usr/bin/ssh-keygen'
readonly KEY_TYPE='rsa'
readonly KEY_SIZE=4096

[ ! -f ${SSH_KGEN} ]                              &&
    echo "Error: unable to find ${SSH_KGEN}" >& 2 &&
    exit 1


function show_usage {
    echo "Usage: ${0} <output-path>" >& 2
}

[ $# -ne 1 ] && show_usage && exit 1


readonly OUT_PATH="$1"
[ ! -d "${OUT_PATH}" ]                                &&
    echo "Error: output path is not a directory" >& 2 &&
    exit 1

# File and comment format.
readonly FMT=`whoami`@`hostname`-`date '+%m%d%Y'`
readonly KEY_FILE="${OUT_PATH}/${FMT}"

echo "#> generating ${KEY_TYPE} key ${KEY_FILE} ..."
${SSH_KGEN} -t ${KEY_TYPE} -b ${KEY_SIZE} -C "${FMT}" -f "${KEY_FILE}"

echo -n "#> fixing permissions on key file ..."
chmod 400 ${KEY_FILE}{,.pub} 2> /dev/null
[ $? -eq 0 ] && echo '  [OK]' && exit 0
echo ' [FAIL]' && exit 1
