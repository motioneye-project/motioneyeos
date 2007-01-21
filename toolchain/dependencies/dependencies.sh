#!/bin/sh

#set -x

echo ""
echo "Checking build system dependencies:"


#############################################################
#
# check build system 'environment'
#
#############################################################
if test -n "$CC" ; then
	echo "CC clean:						FALSE"
	/bin/echo -e "\n\nYou must run 'unset CC' so buildroot can run with";
	/bin/echo -e "a clean environment on your build machine\n";
	exit 1;
fi;
echo "CC clean:					Ok"


if test -n "$CXX" ; then
	echo "CXX clean:					FALSE"
	/bin/echo -e "\n\nYou must run 'unset CXX' so buildroot can run with";
	/bin/echo -e "a clean environment on your build machine\n";
	exit 1;
fi;
echo "CXX clean:					Ok"


if test -n "$CPP" ; then
	echo "CPP clean:					FALSE"
	/bin/echo -e "\n\nYou must run 'unset CPP' so buildroot can run with";
	/bin/echo -e "a clean environment on your build machine\n";
	exit 1;
fi;
echo "CPP clean:					Ok"


if test -n "$CFLAGS" ; then
	echo "CFLAGS clean:					FALSE"
	/bin/echo -e "\n\nYou must run 'unset CFLAGS' so buildroot can run with";
	/bin/echo -e "a clean environment on your build machine\n";
	exit 1;
fi;
echo "CFLAGS clean:					Ok"


if test -n "$CXXFLAGS" ; then
	echo "CXXFLAGS clean:					FALSE"
	/bin/echo -e "\n\nYou must run 'unset CXXFLAGS' so buildroot can run with";
	/bin/echo -e "a clean environment on your build machine\n";
	exit 1;
fi;
echo "CXXFLAGS clean:					Ok"

echo "WORKS" | grep "WORKS" >/dev/null 2>&1
if test $? != 0 ; then
	echo "grep works:				FALSE"
	exit 1
fi

# sanity check for CWD in LD_LIBRARY_PATH
# try not to rely on egrep..
if test -n "$LD_LIBRARY_PATH" ; then
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep ':.:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep 'TRiGGER_start:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep ':TRiGGER_end' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep '::' >/dev/null 2>&1
	if test $? = 0; then
		echo "LD_LIBRARY_PATH sane:				FALSE"
		echo "You seem to have the current working directory in your"
		echo "LD_LIBRARY_PATH environment variable. This doesn't work."
		exit 1;
	else
		echo "LD_LIBRARY_PATH sane:				Ok"
	fi
fi;



#############################################################
#
# check build system 'sed'
#
#############################################################
if test -x /usr/bin/sed ; then
	SED="/usr/bin/sed"
else
	if test -x /bin/sed ; then
		SED="/bin/sed"
	else
		SED="sed"
	fi
fi
echo "HELLO" > .sedtest
$SED -i -e "s/HELLO/GOODBYE/" .sedtest >/dev/null 2>&1
if test $? != 0 ; then
	echo "sed works:				No, using buildroot version instead"
else
	echo "sed works:					Ok"
fi
rm -f .sedtest
XSED=$HOST_SED_DIR/bin/sed

#############################################################
#
# check build system 'which'
#
#############################################################
if ! which which > /dev/null ; then
	echo "which installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'which' on your build machine\n";
	exit 1;
fi;
echo "which installed:				Ok"


#############################################################
#
# check build system 'make'
#
#############################################################
MAKE=$(which make)
if [ -z "$MAKE" ] ; then
	echo "make installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_VERSION=$($MAKE --version 2>&1 | head -n1 | $XSED -e 's/^.* \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g')
if [ -z "$MAKE_VERSION" ] ; then
	echo "make installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_MAJOR=$(echo $MAKE_VERSION | $XSED -e "s/\..*//g")
MAKE_MINOR=$(echo $MAKE_VERSION | $XSED -e "s/^$MAKE_MAJOR\.//g" -e "s/\..*//g" -e "s/[a-zA-Z].*//g")
if [ $MAKE_MAJOR -lt 3 -o $MAKE_MAJOR -eq 3 -a $MAKE_MINOR -lt 8 ] ; then
	echo "You have make '$MAKE_VERSION' installed.  GNU make >=3.80 is required"
	exit 1;
fi;
echo "GNU make version '$MAKE_VERSION':			Ok"



#############################################################
#
# check build system 'gcc'
#
#############################################################
COMPILER=$(which $HOSTCC)
if [ -z "$COMPILER" ] ; then
	COMPILER=$(which cc)
fi;
if [ -z "$COMPILER" ] ; then
	echo "C Compiler installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'gcc' on your build machine\n";
	exit 1;
fi;

COMPILER_VERSION=$($COMPILER --version 2>&1 | head -n1 | $XSED -e 's/^.*(.CC) \([0-9\.]\)/\1/g' -e "s/[-\ ].*//g")
if [ -z "$COMPILER_VERSION" ] ; then
	echo "gcc installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'gcc' on your build machine\n";
	exit 1;
fi;
COMPILER_MAJOR=$(echo $COMPILER_VERSION | $XSED -e "s/\..*//g")
COMPILER_MINOR=$(echo $COMPILER_VERSION | $XSED -e "s/^$COMPILER_MAJOR\.//g" -e "s/\..*//g")
if [ $COMPILER_MAJOR -lt 3 -o $COMPILER_MAJOR -eq 2 -a $COMPILER_MINOR -lt 95 ] ; then
	echo "You have gcc '$COMPILER_VERSION' installed.  gcc >= 2.95 is required"
	exit 1;
fi;
echo "C compiler '$COMPILER'"
echo "C compiler version '$COMPILER_VERSION':			Ok"



#############################################################
#
# check build system 'bison'
#
#############################################################
if ! which bison > /dev/null ; then
	echo "bison installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'bison' on your build machine\n";
	exit 1;
fi;
echo "bison installed:				Ok"


#############################################################
#
# check build system 'flex'
#
#############################################################
if ! which flex > /dev/null ; then
	echo "flex installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'flex' on your build machine\n";
	exit 1;
fi;
echo "flex installed:					Ok"


#############################################################
#
# check build system 'gettext'
#
#############################################################
if ! which msgfmt > /dev/null ; then \
	echo "gettext installed:		    FALSE"
	/bin/echo -e "\n\nYou must install 'gettext' on your build machine\n"; \
	exit 1; \
fi;
echo "gettext installed:				Ok"





#############################################################
#
# All done
#
#############################################################
echo "Build system dependencies:			Ok"
echo ""

