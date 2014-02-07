#! /bin/bash
# A little script I whipped up to make it easy to
# patch source trees and have sane error handling
# -Erik
#
# (c) 2002 Erik Andersen <andersen@codepoet.org>
#
# Parameters:
# - the build directory, optional, default value is '.'. The place where are
# the package sources.
# - the patch directory, optional, default '../kernel-patches'. The place
# where are the scripts you want to apply.
# - other parameters are the patch name patterns, optional, default value is
# '*'. Pattern(s) describing the patch names you want to apply.
#
# The script will look recursively for patches from the patch directory. If a
# file is named 'series' then only patches mentionned into it will be applied.
# If not, the script will look for file names matching pattern(s). If the name
# ends with '.tar.*', '.tbz2' or '.tgz', the file is considered as an archive
# and will be uncompressed into a directory named
# '.patches-name_of_the_archive-unpacked'. It's the turn of this directory to
# be scanned with '*' as pattern. Remember that scanning is recursive. Other
# files than series file and archives are considered as a patch.
#
# Once a patch is found, the script will try to apply it. If its name doesn't
# end with '.gz', '.bz', '.bz2', '.xz', '.zip', '.Z', '.diff*' or '.patch*',
# it will be skipped. If necessary, the patch will be uncompressed before being
# applied. The list of the patches applied is stored in '.applied_patches_list'
# file in the build directory.

# Set directories from arguments, or use defaults.
builddir=${1-.}
patchdir=${2-../kernel-patches}
shift 2
patchpattern=${@-*}

# use a well defined sorting order
export LC_COLLATE=C

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
	*.xz)
	type="xz"; uncomp="unxz -dc"; ;;
	*.zip)
	type="zip"; uncomp="unzip -d"; ;; 
	*.Z)
	type="compress"; uncomp="uncompress -c"; ;; 
	*.diff*)
	type="diff"; uncomp="cat"; ;;
	*.patch*)
	type="patch"; uncomp="cat"; ;;
	*)
	echo "Unsupported file type for ${path}/${patch}, skipping";
	return 0
	;;
    esac
    echo ""
    echo "Applying $patch using ${type}: "
    if [ ! -e "${path}/$patch" ] ; then
	echo "Error: missing patch file ${path}/$patch"
	exit 1
    fi
    echo $patch >> ${builddir}/.applied_patches_list
    ${uncomp} "${path}/$patch" | patch -g0 -p1 -E -d "${builddir}" -t -N
    if [ $? != 0 ] ; then
        echo "Patch failed!  Please fix ${patch}!"
	exit 1
    fi
}

function scan_patchdir {
    local path=$1
    shift 1
    patches=${@-*}

    # If there is a series file, use it instead of using ls sort order
    # to apply patches. Skip line starting with a dash.
    if [ -e "${path}/series" ] ; then
        for i in `grep -Ev "^#" ${path}/series 2> /dev/null` ; do
            apply_patch "$path" "$i"
        done
    else
        for i in `cd $path; ls -d $patches 2> /dev/null` ; do
            if [ -d "${path}/$i" ] ; then
                scan_patchdir "${path}/$i"
            elif echo "$i" | grep -q -E "\.tar(\..*)?$|\.tbz2?$|\.tgz$" ; then
                unpackedarchivedir="$builddir/.patches-$(basename $i)-unpacked"
                rm -rf "$unpackedarchivedir" 2> /dev/null
                mkdir "$unpackedarchivedir"
                tar -C "$unpackedarchivedir" -xaf "${path}/$i"
                scan_patchdir "$unpackedarchivedir"
            else
                apply_patch "$path" "$i"
            fi
        done
    fi
}

scan_patchdir "$patchdir" "$patchpattern"

# Check for rejects...
if [ "`find $builddir/ '(' -name '*.rej' -o -name '.*.rej' ')' -print`" ] ; then
    echo "Aborting.  Reject files found."
    exit 1
fi

# Remove backup files
find $builddir/ '(' -name '*.orig' -o -name '.*.orig' ')' -exec rm -f {} \;
