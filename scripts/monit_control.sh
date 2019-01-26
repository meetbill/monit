#!/bin/bash
#########################################################################
# File Name: monit_control.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2019-01-26 23:48:53
#########################################################################

CUR_DIR=$(cd `dirname $0`; pwd)
DISP_NAME="bdrp-monit"
MAIN_FILE="${CUR_DIR}/bin/monit -c ${CUR_DIR}/conf/monitrc"
MAIN_FILE_current=${MAIN_FILE}
STDOUT="./__stdout"
# Consts
RED='\e[1;91m'
GREN='\e[1;92m'
WITE='\e[1;97m'
NC='\e[0m'
VERSION="1.0.0.4"

# Global vailables
PROC_COUNT="0"
function count_proc()
{
    PROC_COUNT=$(ps -ef | grep "${MAIN_FILE_current}" | grep -vc grep)
}
function list_proc()
{
    ps -ef | grep -v grep | grep --color "${MAIN_FILE_current}"
}
function list_proc_pids()
{
    ps -ef | grep "${MAIN_FILE_current}" | grep -v grep | awk '{print $2}'
}
function init_config()
{
    # init_config
    bash ./scripts/init_config.sh
}
function init_service()
{
    # monit all service
    ${MAIN_FILE} monitor all

}
function start_procs()
{
    printf "Starting $DISP_NAME processes"
    count_proc
    if [ $PROC_COUNT \> 0 ]; then
        stop_procs
        #echo
        #list_proc
        #echo -e ${RED}"\n[ERROR]" ${NC}"Start $DISP_NAME failed, processes already runing."
        #exit -1
    fi

    init_config
    $MAIN_FILE  1>$STDOUT 2>&1

    sleep 1
    list_proc
    count_proc
    if [ $PROC_COUNT == 0 ]; then
        echo -e ${RED}"\n[ERROR]" ${NC}"Start $DISP_NAME failed."
        exit -1
    fi
    init_service

    echo -e ${GREN}"\n[OK]" ${NC}"$DISP_NAME start succesfully."
}

function stop_procs()
{
    printf "Stoping $DISP_NAME"
    count_proc
    if [ ${PROC_COUNT} -eq 0 ]; then
        echo -e ${RED}"\n[ERROR]" ${NC}"$DISP_NAME process not found."
        exit -1
    fi

    kill -15 $(list_proc_pids)
    count_proc
    while [ ${PROC_COUNT} -ne 0 ]; do
        printf "."
        sleep 0.2
        count_proc
    done
    echo -e ${GREN}"\n[OK]" ${NC}"$DISP_NAME stop succesfully."
}

function status_procs()
{
    count_proc
    echo -e ${RED}${PROC_COUNT}${NC} "$DISP_NAME processes runing."
}
function monit_exe()
{
    action=$@
    echo -e ${WITE}"[action]:${action}"${NC}
    if [[ -z ${action} ]] ;then   ${MAIN_FILE} -h ; exit -1 ;fi
    echo -e ${WITE}"[exe]:${MAIN_FILE} ${action}"${NC}
    ${MAIN_FILE} ${action}
}

function version_script()
{
    echo "[version]:${VERSION}"
}

MODE=${1}
case ${MODE} in
    "init")
        init_config
        ;;

    "start")
        start_procs
        ;;

    "stop")
        stop_procs
        ;;

    "restart")
        stop_procs
        start_procs
        ;;

    "status")
        status_procs
        ;;

    "monit")
        monit_exe ${@:2}
        ;;

    "version")
        version_script
        ;;
    *)
        # usage
        echo -e "\nUsage: $0 {start|stop|restart|status}"
        echo -e ${WITE}" init           "${NC}"Init $DISP_NAME configfile."
        echo -e ${WITE}" start          "${NC}"Start $DISP_NAME processes."
        echo -e ${WITE}" stop           "${NC}"Kill all $DISP_NAME processes."
        echo -e ${WITE}" restart        "${NC}"Kill all $DISP_NAME processes and start again."
        echo -e ${WITE}" status         "${NC}"Show $DISP_NAME processes status."
        echo -e ${WITE}" monit action   "${NC}"exe $DISP_NAME action"
        echo -e ${WITE}" version        "${NC}"Show $0 script version.\n"
        exit 1
        ;;
esac
