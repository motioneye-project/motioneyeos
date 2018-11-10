#!/bin/sh
# vi: set sw=4 ts=4:

export LC_ALL=C

# Verify that grep works
echo "WORKS" | grep "WORKS" >/dev/null 2>&1
if test $? != 0 ; then
	echo
	echo "grep doesn't work"
	exit 1
fi

# Sanity check for CWD in LD_LIBRARY_PATH
case ":${LD_LIBRARY_PATH:-unset}:" in
(*::*|*:.:*)
	echo
	echo "You seem to have the current working directory in your"
	echo "LD_LIBRARY_PATH environment variable. This doesn't work."
	exit 1
	;;
esac

# Sanity check for CWD in PATH. Having the current working directory
# in the PATH makes various packages (e.g. toolchain, coreutils...)
# build process break.
# PATH should not contain a newline, otherwise it fails in spectacular
# ways as soon as PATH is referenced in a package rule
# An empty PATH is technically possible, but in practice we would not
# even arrive here if that was the case.
case ":${PATH:-unset}:" in
(*::*|*:.:*)
	echo
	echo "You seem to have the current working directory in your"
	echo "PATH environment variable. This doesn't work."
	exit 1
	;;
(*"
"*)	printf "\n"
	# Break the '\n' sequence, or a \n is printed (which is not what we want).
	printf "Your PATH contains a newline (%sn) character.\n" "\\"
	printf "This doesn't work. Fix you PATH.\n"
	exit 1
	;;
esac

if test -n "$PERL_MM_OPT" ; then
	echo
	echo "You have PERL_MM_OPT defined because Perl local::lib"
	echo "is installed on your system. Please unset this variable"
	echo "before starting Buildroot, otherwise the compilation of"
	echo "Perl related packages will fail"
	exit 1
fi

check_prog_host()
{
	prog="$1"
	if ! which $prog > /dev/null ; then
		echo >&2
		echo "You must install '$prog' on your build machine" >&2
		exit 1
	fi
}

# Verify that which is installed
check_prog_host "which"
# Verify that sed is installed
check_prog_host "sed"

# 'file' must be present and must be exactly /usr/bin/file,
# otherwise libtool fails in incomprehensible ways.
check_prog_host "/usr/bin/file"

# Check make
MAKE=$(which make 2> /dev/null)
if [ -z "$MAKE" ] ; then
	echo
	echo "You must install 'make' on your build machine";
	exit 1;
fi;
MAKE_VERSION=$($MAKE --version 2>&1 | sed -e 's/^.* \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
if [ -z "$MAKE_VERSION" ] ; then
	echo
	echo "You must install 'make' on your build machine";
	exit 1;
fi;
MAKE_MAJOR=$(echo $MAKE_VERSION | sed -e "s/\..*//g")
MAKE_MINOR=$(echo $MAKE_VERSION | sed -e "s/^$MAKE_MAJOR\.//g" -e "s/\..*//g" -e "s/[a-zA-Z].*//g")
if [ $MAKE_MAJOR -lt 3 ] || [ $MAKE_MAJOR -eq 3 -a $MAKE_MINOR -lt 81 ] ; then
	echo
	echo "You have make '$MAKE_VERSION' installed.  GNU make >=3.81 is required"
	exit 1;
fi;

# Check host gcc
COMPILER=$(which $HOSTCC_NOCCACHE 2> /dev/null)
if [ -z "$COMPILER" ] ; then
	COMPILER=$(which cc 2> /dev/null)
fi;
if [ -z "$COMPILER" ] ; then
	echo
	echo "You must install 'gcc' on your build machine";
	exit 1;
fi;

COMPILER_VERSION=$($COMPILER -v 2>&1 | sed -n '/^gcc version/p' |
	sed -e 's/^gcc version \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
if [ -z "$COMPILER_VERSION" ] ; then
	echo
	echo "You must install 'gcc' on your build machine";
	exit 1;
fi;
COMPILER_MAJOR=$(echo $COMPILER_VERSION | sed -e "s/\..*//g")
COMPILER_MINOR=$(echo $COMPILER_VERSION | sed -e "s/^$COMPILER_MAJOR\.//g" -e "s/\..*//g")
if [ $COMPILER_MAJOR -lt 3 -o $COMPILER_MAJOR -eq 2 -a $COMPILER_MINOR -lt 95 ] ; then
	echo
	echo "You have gcc '$COMPILER_VERSION' installed.  gcc >= 2.95 is required"
	exit 1;
fi;

# check for host CXX
CXXCOMPILER=$(which $HOSTCXX_NOCCACHE 2> /dev/null)
if [ -z "$CXXCOMPILER" ] ; then
	CXXCOMPILER=$(which c++ 2> /dev/null)
fi

if [ -z "$CXXCOMPILER" ] ; then
	echo
	echo "You may have to install 'g++' on your build machine"
fi
if [ ! -z "$CXXCOMPILER" ] ; then
	CXXCOMPILER_VERSION=$($CXXCOMPILER -v 2>&1 | sed -n '/^gcc version/p' |
		sed -e 's/^gcc version \([0-9\.]\)/\1/g' -e 's/[-\ ].*//g' -e '1q')
	if [ -z "$CXXCOMPILER_VERSION" ] ; then
		echo
		echo "You may have to install 'g++' on your build machine"
	fi
fi

if [ -n "$CXXCOMPILER_VERSION" ] ; then
	CXXCOMPILER_MAJOR=$(echo $CXXCOMPILER_VERSION | sed -e "s/\..*//g")
	CXXCOMPILER_MINOR=$(echo $CXXCOMPILER_VERSION | sed -e "s/^$CXXCOMPILER_MAJOR\.//g" -e "s/\..*//g")
	if [ $CXXCOMPILER_MAJOR -lt 3 -o $CXXCOMPILER_MAJOR -eq 2 -a $CXXCOMPILER_MINOR -lt 95 ] ; then
		echo
		echo "You have g++ '$CXXCOMPILER_VERSION' installed.  g++ >= 2.95 is required"
		exit 1
	fi
fi

# Check bash
# We only check bash is available, setting SHELL appropriately is done
# in the top-level Makefile, and we mimick the same sequence here
if   [ -n "${BASH}" ]; then :
elif [ -x /bin/bash ]; then :
elif [ -z "$( sh -c 'echo $BASH' )" ]; then
	echo
	echo "You must install 'bash' on your build machine"
	exit 1
fi

# Check that a few mandatory programs are installed
missing_progs="no"
for prog in patch perl tar wget cpio python unzip rsync bc ${DL_TOOLS} ; do
	if ! which $prog > /dev/null ; then
		echo "You must install '$prog' on your build machine";
		missing_progs="yes"
		if test $prog = "svn" ; then
			echo "  svn is usually part of the subversion package in your distribution"
		elif test $prog = "hg" ; then
			echo "  hg is usually part of the mercurial package in your distribution"
		elif test $prog = "zcat" ; then
			echo "  zcat is usually part of the gzip package in your distribution"
		elif test $prog = "bzcat" ; then
			echo "  bzcat is usually part of the bzip2 package in your distribution"
		fi
	fi
done

if test "${missing_progs}" = "yes" ; then
	exit 1
fi

if grep ^BR2_NEEDS_HOST_UTF8_LOCALE=y $BR2_CONFIG > /dev/null; then
	if ! which locale > /dev/null ; then
		echo
		echo "You need locale support on your build machine to build a toolchain supporting locales"
		exit 1 ;
	fi
	if ! locale -a | grep -q -i -E 'utf-?8$' ; then
		echo
		echo "You need at least one UTF8 locale to build a toolchain supporting locales"
		exit 1 ;
	fi
fi

if grep -q ^BR2_NEEDS_HOST_JAVA=y $BR2_CONFIG ; then
	check_prog_host "java"
	JAVA_GCJ=$(java -version 2>&1 | grep gcj)
	if [ ! -z "$JAVA_GCJ" ] ; then
		echo
		echo "$JAVA_GCJ is not sufficient to compile your package selection."
		echo "Please install an OpenJDK/IcedTea/Oracle Java."
		exit 1 ;
	fi
fi

if grep -q ^BR2_NEEDS_HOST_JAVAC=y $BR2_CONFIG ; then
	check_prog_host "javac"
fi

if grep -q ^BR2_NEEDS_HOST_JAR=y $BR2_CONFIG ; then
	check_prog_host "jar"
fi

if grep -q ^BR2_HOSTARCH_NEEDS_IA32_LIBS=y $BR2_CONFIG ; then
	if test ! -f /lib/ld-linux.so.2 ; then
		echo
		echo "Your Buildroot configuration uses pre-built tools for the x86 architecture,"
		echo "but your build machine uses the x86-64 architecture without the 32 bits compatibility"
		echo "library."
		echo "If you're running a Debian/Ubuntu distribution, install the libc6-i386,"
		echo "lib32stdc++6, and lib32z1 packages (or alternatively libc6:i386,"
		echo "libstdc++6:i386, and zlib1g:i386)."
		echo "If you're running a RedHat/Fedora distribution, install the glibc.i686 and"
		echo "zlib.i686 packages."
		echo "For other distributions, refer to the documentation on how to install the 32 bits"
		echo "compatibility libraries."
		exit 1
	fi
fi

if grep -q ^BR2_HOSTARCH_NEEDS_IA32_COMPILER=y $BR2_CONFIG ; then
	if ! echo "int main(void) {}" | gcc -m32 -x c - -o /dev/null 2>/dev/null; then
		echo
		echo "Your Buildroot configuration needs a compiler capable of building 32 bits binaries."
		echo "If you're running a Debian/Ubuntu distribution, install the gcc-multilib package."
		echo "For other distributions, refer to their documentation."
		exit 1
	fi

	if ! echo "int main(void) {}" | g++ -m32 -x c++ - -o /dev/null 2>/dev/null; then
		echo
		echo "Your Buildroot configuration needs a compiler capable of building 32 bits binaries."
		echo "If you're running a Debian/Ubuntu distribution, install the g++-multilib package."
		echo "For other distributions, refer to their documentation."
		exit 1
	fi
fi

# Check that the Perl installation is complete enough for Buildroot.
required_perl_modules="Data::Dumper" # Needed to build host-autoconf
required_perl_modules="$required_perl_modules ExtUtils::MakeMaker" # Used by host-libxml-parser-perl
required_perl_modules="$required_perl_modules Thread::Queue" # Used by host-automake

if grep -q ^BR2_PACKAGE_MPV=y $BR2_CONFIG ; then
    required_perl_modules="$required_perl_modules Math::BigInt"
    required_perl_modules="$required_perl_modules Math::BigRat"
fi

# This variable will keep the modules that are missing in your system.
missing_perl_modules=""

for pm in $required_perl_modules ; do
	if ! perl  -e "require $pm" > /dev/null 2>&1 ; then
		missing_perl_modules="$missing_perl_modules $pm"
	fi
done

if [ -n "$missing_perl_modules" ] ; then
	echo "Your Perl installation is not complete enough; at least the following"
	echo "modules are missing:"
	echo
	for pm in $missing_perl_modules ; do
		printf "\t $pm\n"
	done
	echo
	exit 1
fi

if ! python -c "import argparse" > /dev/null 2>&1 ; then
	echo "Your Python installation is not complete enough: argparse module is missing"
	exit 1
fi
