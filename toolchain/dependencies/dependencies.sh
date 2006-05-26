#!/bin/sh

set -e
#set -x

echo "Checking build system dependencies:"
echo ""


#############################################################
#
# check build system 'make'
#
#############################################################
MAKE=$(which make)
if [ -z "$MAKE" ] ; then
	echo "make installed:		    FALSE"
	echo -e "\n\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_VERSION=$($MAKE --version 2>&1 | head -n1 | sed -e 's/^.* \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g')
if [ -z "$MAKE_VERSION" ] ; then
	echo "make installed:		    FALSE"
	echo -e "\n\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_MAJOR=$(echo $MAKE_VERSION | sed -e "s/\..*//g")
MAKE_MINOR=$(echo $MAKE_VERSION | sed -e "s/^$MAKE_MAJOR\.//g" -e "s/\..*//g")
if [ $MAKE_MAJOR -lt 3 -o $MAKE_MAJOR -eq 3 -a $MAKE_MINOR -lt 8 ] ; then
	echo "You have make '$MAKE_VERSION' installed.  GNU make >=3.80 is required"
	exit 1;
fi;
echo "GNU make version '$MAKE_VERSION':	    Ok"



#############################################################
#
# check build system 'gcc'
#
#############################################################
COMPILER=$(which gcc)
if [ -z "$COMPILER" ] ; then
	COMPILER=$(which cc)
	if [ -z "$COMPILER" ] ; then
		echo "gcc installed:		    FALSE"
		echo -e "\n\nYou must install 'gcc' on your build machine\n";
		exit 1;
	fi;
fi;
COMPILER_VERSION=$($COMPILER --version 2>&1 | head -n1 | sed -e 's/^.* \([0-9\.]\)/\1/g' -e "s/[-\ ].*//g")
if [ -z "$COMPILER_VERSION" ] ; then
	echo "gcc installed:		    FALSE"
	echo -e "\n\nYou must install 'gcc' on your build machine\n";
	exit 1;
fi;
COMPILER_MAJOR=$(echo $COMPILER_VERSION | sed -e "s/\..*//g")
COMPILER_MINOR=$(echo $COMPILER_VERSION | sed -e "s/^$COMPILER_MAJOR\.//g" -e "s/\..*//g")
if [ $COMPILER_MAJOR -lt 3 -o $COMPILER_MAJOR -eq 2 -a $COMPILER_MINOR -lt 95 ] ; then
	echo "You have gcc '$COMPILER_VERSION' installed.  gcc >= 2.95 is required"
	exit 1;
fi;
echo "gcc version '$COMPILER_VERSION':		    Ok"




#############################################################
#
# check build system 'which'
#
#############################################################
if ! which which > /dev/null ; then
	echo "which installed:		    FALSE"
	echo -e "\n\nYou must install 'which' on your build machine\n";
	exit 1;
fi;
echo "which installed:		    Ok"


#############################################################
#
# check build system 'bison'
#
#############################################################
if ! which bison > /dev/null ; then
	echo "bison installed:		    FALSE"
	echo -e "\n\nYou must install 'bison' on your build machine\n";
	exit 1;
fi;
echo "bison installed:		    Ok"


#############################################################
#
# check build system 'flex'
#
#############################################################
if ! which flex > /dev/null ; then
	echo "flex installed:		    FALSE"
	echo -e "\n\nYou must install 'flex' on your build machine\n";
	exit 1;
fi;
echo "flex installed:			    Ok"


#############################################################
#
# check build system 'gettext'
#
#############################################################
if ! which msgfmt > /dev/null ; then \
	echo "gettext installed:		    FALSE"
	echo -e "\n\nYou must install 'gettext' on your build machine\n"; \
	exit 1; \
fi;
echo "gettext installed:		    Ok"





#############################################################
#
# All done
#
#############################################################
echo "Build system dependencies:	    Ok"

