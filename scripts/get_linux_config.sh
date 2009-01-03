#!/bin/bash
#######################################################################
#
# Copy successively all configs from the BSP directory (par #1)
# to the Linux directory (par #2)
# Do not copy config files for later linux versions than the current
# A well-behaved filename is 
# "<name>-linux-2.6.<major>.<minor>.config" or
# "<name>-linux-2.6.<major>.config"
#
#######################################################################

TOPDIR=`pwd`
DEBUG=0
# parameter #1	BOARD_PATH
# parameter #2  LINUX26_DIR

CONFIGS=`ls -X $1/*linux-2.6.*.config | sed s/[.]config// - | sort`
LINUX26_DIR=`basename $2`
LINUX26_CONFIG=${2}/.config
LINUX_MAJOR_VERSION=${LINUX26_DIR:10:2}
LINUX_MINOR_VERSION=${LINUX26_DIR:13}

function DBG_PRINT
{
	if [ ${DEBUG} == 1 ] ; then
		echo $1
	fi
}

function linux_version()
{
	local KCONFIG
	KCONFIG=`basename $1`
	KERNEL=`echo ${KCONFIG} | sed s/.*linux-2.6./linux-2.6./g -`
	THIS_MAJOR=${KERNEL:10:2}
	THIS_MINOR=${KERNEL:13}
}

# Try to be careful...
DBG_PRINT MAJOR=\"${LINUX_MAJOR_VERSION}\"
DBG_PRINT MINOR=\"${LINUX_MINOR_VERSION}\"

for i in ${CONFIGS} ; do
    DBG_PRINT FILE=$i
    linux_version $i
    DBG_PRINT KERNEL=${KERNEL}
    if [ ${THIS_MAJOR} -lt ${LINUX_MAJOR_VERSION} ] ; then
	    echo Copying `basename $i`.config ...
	    cp $i.config ${LINUX26_CONFIG}
    elif [ ${THIS_MAJOR} -eq ${LINUX_MAJOR_VERSION} ] ; then
	if [ "${LINUX_MINOR_VERSION}X" == "X" ] ; then
		if [ "${THIS_MINOR}X" == "X" ] ; then
		    echo Copying `basename $i`.config ...
		    cp $i.config ${LINUX26_CONFIG}
		else		
			return
		fi
	elif [ ${THIS_MINOR} -le ${LINUX_MINOR_VERSION} ] ; then
	    echo Copying `basename $i`.config ...
	    cp $i.config ${LINUX26_CONFIG}
	fi
    else		
	return
    fi
done

# Did not work... - be promisceous

if [ ! -f "${LINUX26_CONFIG}" ] ; then \
	for i in `ls $1/*linux*.config` ; do
		echo Copying `basename $i` ...
		cp $i ${LINUX26_CONFIG}
	done
fi

