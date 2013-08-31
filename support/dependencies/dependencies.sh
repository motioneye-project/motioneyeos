#!/bin/sh
# vi: set sw=4 ts=4:
#set -x

export LC_ALL=C

# Verify that grep works
echo "WORKS" | grep "WORKS" >/dev/null 2>&1
if test $? != 0 ; then
	/bin/echo -e "\ngrep doesn't work\n"
	exit 1
fi

# sanity check for CWD in LD_LIBRARY_PATH
# try not to rely on egrep..
if test -n "$LD_LIBRARY_PATH" ; then
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep ':\.:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep 'TRiGGER_start\.:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep ':\.TRiGGER_end' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$LD_LIBRARY_PATH"TRiGGER_end | /bin/grep 'TRiGGER_start\.TRiGGER_end' >/dev/null 2>&1
	if test $? = 0; then
		/bin/echo -e "\nYou seem to have the current working directory in your"
		/bin/echo -e "LD_LIBRARY_PATH environment variable. This doesn't work.\n"
		exit 1;
	fi
fi;

# sanity check for CWD in PATH. Having the current working directory
# in the PATH makes the toolchain build process break.
# try not to rely on egrep..
if test -n "$PATH" ; then
	/bin/echo TRiGGER_start"$PATH"TRiGGER_end | /bin/grep ':\.:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$PATH"TRiGGER_end | /bin/grep 'TRiGGER_start\.:' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$PATH"TRiGGER_end | /bin/grep ':\.TRiGGER_end' >/dev/null 2>&1 ||
	/bin/echo TRiGGER_start"$PATH"TRiGGER_end | /bin/grep 'TRiGGER_start\.TRiGGER_end' >/dev/null 2>&1
	if test $? = 0; then
		/bin/echo -e "\nYou seem to have the current working directory in your"
		/bin/echo -e "PATH environment variable. This doesn't work.\n"
		exit 1;
	fi
fi;

if test -n "$PERL_MM_OPT" ; then
    /bin/echo -e "\nYou have PERL_MM_OPT defined because Perl local::lib"
    /bin/echo -e "is installed on your system. Please unset this variable"
    /bin/echo -e "before starting Buildroot, otherwise the compilation of"
    /bin/echo -e "Perl related packages will fail"
    exit 1
fi

# Verify that which is installed
if ! which which > /dev/null ; then
	/bin/echo -e "\nYou must install 'which' on your build machine\n";
	exit 1;
fi;

if ! which sed > /dev/null ; then
	/bin/echo -e "\nYou must install 'sed' on your build machine\n"
	exit 1
fi

# Check make
MAKE=$(which make 2> /dev/null)
if [ -z "$MAKE" ] ; then
	/bin/echo -e "\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_VERSION=$($MAKE --version 2>&1 | sed -e 's/^.* \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
if [ -z "$MAKE_VERSION" ] ; then
	/bin/echo -e "\nYou must install 'make' on your build machine\n";
	exit 1;
fi;
MAKE_MAJOR=$(echo $MAKE_VERSION | sed -e "s/\..*//g")
MAKE_MINOR=$(echo $MAKE_VERSION | sed -e "s/^$MAKE_MAJOR\.//g" -e "s/\..*//g" -e "s/[a-zA-Z].*//g")
if [ $MAKE_MAJOR -lt 3 ] || [ $MAKE_MAJOR -eq 3 -a $MAKE_MINOR -lt 81 ] ; then
	/bin/echo -e "\nYou have make '$MAKE_VERSION' installed.  GNU make >=3.81 is required\n"
	exit 1;
fi;

# Check host gcc
COMPILER=$(which $HOSTCC_NOCCACHE 2> /dev/null)
if [ -z "$COMPILER" ] ; then
	COMPILER=$(which cc 2> /dev/null)
fi;
if [ -z "$COMPILER" ] ; then
	/bin/echo -e "\nYou must install 'gcc' on your build machine\n";
	exit 1;
fi;

COMPILER_VERSION=$($COMPILER -v 2>&1 | sed -n '/^gcc version/p' |
	sed -e 's/^gcc version \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
if [ -z "$COMPILER_VERSION" ] ; then
	/bin/echo -e "\nYou must install 'gcc' on your build machine\n";
	exit 1;
fi;
COMPILER_MAJOR=$(echo $COMPILER_VERSION | sed -e "s/\..*//g")
COMPILER_MINOR=$(echo $COMPILER_VERSION | sed -e "s/^$COMPILER_MAJOR\.//g" -e "s/\..*//g")
if [ $COMPILER_MAJOR -lt 3 -o $COMPILER_MAJOR -eq 2 -a $COMPILER_MINOR -lt 95 ] ; then
	echo "\nYou have gcc '$COMPILER_VERSION' installed.  gcc >= 2.95 is required\n"
	exit 1;
fi;

# check for host CXX
CXXCOMPILER=$(which $HOSTCXX_NOCCACHE 2> /dev/null)
if [ -z "$CXXCOMPILER" ] ; then
	CXXCOMPILER=$(which c++ 2> /dev/null)
fi
if [ -z "$CXXCOMPILER" ] ; then
	/bin/echo -e "\nYou may have to install 'g++' on your build machine\n"
	#exit 1
fi
if [ ! -z "$CXXCOMPILER" ] ; then
	CXXCOMPILER_VERSION=$($CXXCOMPILER -v 2>&1 | sed -n '/^gcc version/p' |
		sed -e 's/^gcc version \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
	if [ -z "$CXXCOMPILER_VERSION" ] ; then
		/bin/echo -e "\nYou may have to install 'g++' on your build machine\n"
	fi

	CXXCOMPILER_MAJOR=$(echo $CXXCOMPILER_VERSION | sed -e "s/\..*//g")
	CXXCOMPILER_MINOR=$(echo $CXXCOMPILER_VERSION | sed -e "s/^$CXXCOMPILER_MAJOR\.//g" -e "s/\..*//g")
	if [ $CXXCOMPILER_MAJOR -lt 3 -o $CXXCOMPILER_MAJOR -eq 2 -a $CXXCOMPILER_MINOR -lt 95 ] ; then
		/bin/echo -e "\nYou have g++ '$CXXCOMPILER_VERSION' installed.  g++ >= 2.95 is required\n"
		exit 1
	fi
fi

# Check bash
if ! $SHELL --version 2>&1 | grep -q '^GNU bash'; then
	/bin/echo -e "\nYou must install 'bash' on your build machine\n";
	exit 1;
fi;

# Check that a few mandatory programs are installed
missing_progs="no"
for prog in patch perl tar wget cpio python unzip rsync bc ${DL_TOOLS} ; do
    if ! which $prog > /dev/null ; then
	/bin/echo -e "You must install '$prog' on your build machine";
	missing_progs="yes"
	if test $prog = "svn" ; then
	    /bin/echo -e "  svn is usually part of the subversion package in your distribution"
	elif test $prog = "hg" ; then
            /bin/echo -e "  hg is usually part of the mercurial package in your distribution"
	elif test $prog = "zcat" ; then
            /bin/echo -e "  zcat is usually part of the gzip package in your distribution"
	elif test $prog = "bzcat" ; then
            /bin/echo -e "  bzcat is usually part of the bzip2 package in your distribution"
	fi
    fi
done

if test "${missing_progs}" = "yes" ; then
    exit 1
fi

if grep ^BR2_TOOLCHAIN_BUILDROOT=y $BUILDROOT_CONFIG > /dev/null && \
   grep ^BR2_ENABLE_LOCALE=y       $BUILDROOT_CONFIG > /dev/null ; then
   if ! which locale > /dev/null ; then
       /bin/echo -e "\nYou need locale support on your build machine to build a toolchain supporting locales\n"
       exit 1 ;
   fi
   if ! locale -a | grep -q -i utf8$ ; then
       /bin/echo -e "\nYou need at least one UTF8 locale to build a toolchain supporting locales\n"
       exit 1 ;
   fi
fi

if grep -q ^BR2_PACKAGE_CLASSPATH=y $BUILDROOT_CONFIG ; then
    for prog in javac jar; do
	if ! which $prog > /dev/null ; then
	    /bin/echo -e "\nYou must install '$prog' on your build machine\n" >&2
	    exit 1
	fi
    done
fi

if grep -q ^BR2_HOSTARCH_NEEDS_IA32_LIBS=y $BUILDROOT_CONFIG ; then
    if test ! -f /lib/ld-linux.so.2 ; then
	/bin/echo -e "\nYour Buildroot configuration uses pre-built tools for the x86 architecture,"
	/bin/echo -e "but your build machine uses the x86-64 architecture without the 32 bits compatibility"
	/bin/echo -e "library."
	/bin/echo -e "If you're running a Debian/Ubuntu distribution, install the libc:i386 package."
	/bin/echo -e "For other distributions, refer to the documentation on how to install the 32 bits"
	/bin/echo -e "compatibility libraries."
	exit 1
    fi
fi

# Check that the Perl installation is complete enough to build
# host-autoconf.
if ! perl  -e "require Data::Dumper" > /dev/null 2>&1 ; then
    /bin/echo -e "Your Perl installation is not complete enough, at least Data::Dumper is missing."
    /bin/echo -e "On Debian/Ubuntu distributions, install the 'perl' package."
    exit 1
fi
