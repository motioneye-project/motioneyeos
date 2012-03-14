#! /bin/bash
# A little script I whipped up to make it easy to
# patch source trees and have sane error handling
# -Erik
#
# (c) 2002 Erik Andersen <andersen@codepoet.org>

# Set directories from arguments, or use defaults.
builddir=${1-.}
patchdir=${2-../kernel-patches}
shift 2
patchpattern=${@-*}

if [ ! -d "${builddir}" ] ; then
    echo "Aborting.  '${builddir}' is not a directory."
    exit 1
fi
if [ ! -d "${patchdir}" ] ; then
    echo "Aborting.  '${patchdir}' is not a directory."
    exit 1
fi

# Remove any rejects present BEFORE patching - Because if there are
# any, even if patches are well applied, at the end it will complain
# about rejects in builddir.
find ${builddir}/ '(' -name '*.rej' -o -name '.*.rej' ')' -print0 | \
    xargs -0 -r rm -f

function apply_patch {
    path=$1
    patch=$2
    case "$patch" in
	*.gz)
	type="gzip"; uncomp="gunzip -dc"; ;; 
	*.bz)
	type="bzip"; uncomp="bunzip -dc"; ;; 
	*.bz2)
	type="bzip2"; uncomp="bunzip2 -dc"; ;; 
	*.zip)
	type="zip"; uncomp="unzip -d"; ;; 
	*.Z)
	type="compress"; uncomp="uncompress -c"; ;; 
	*)
	type="plaintext"; uncomp="cat"; ;; 
    esac
    echo ""
    echo "Applying $patch using ${type}: "
	echo $patch >> ${builddir}/.applied_patches_list
    ${uncomp} "${path}/$patch" | patch -g0 -p1 -E -d "${builddir}"
    if [ $? != 0 ] ; then
        echo "Patch failed!  Please fix ${patch}!"
	exit 1
    fi
}

function scan_patchdir {
    path=$1
    shift 1
    patches=${@-*}

    for i in `cd $path; ls -d $patches 2> /dev/null` ; do
        if [ -d "${path}/$i" ] ; then
            echo "${path}/$i skipped"
        elif echo "$i" | grep -q -E "\.tar(\..*)?$|\.tbz2?$|\.tgz$" ; then
            unpackedarchivedir="$builddir/.patches-$(basename $i)-unpacked"
            rm -rf "$unpackedarchivedir" 2> /dev/null
            mkdir "$unpackedarchivedir"
            tar -C "$unpackedarchivedir" --strip-components=1 -xaf "${path}/$i"
            scan_patchdir "$unpackedarchivedir"
        else
            apply_patch "$path" "$i" || exit 1
        fi
    done
}

scan_patchdir $patchdir $patchpattern

# Check for rejects...
if [ "`find $builddir/ '(' -name '*.rej' -o -name '.*.rej' ')' -print`" ] ; then
    echo "Aborting.  Reject files found."
    exit 1
fi

# Remove backup files
find $builddir/ '(' -name '*.orig' -o -name '.*.orig' ')' -exec rm -f {} \;
