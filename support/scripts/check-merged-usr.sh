#!/bin/sh
#
# Check if a given custom skeleton or overlay complies to the merged /usr
# requirements:
# /
# /bin -> usr/bin
# /lib -> usr/lib
# /sbin -> usr/sbin
# /usr/bin/
# /usr/lib/
# /usr/sbin/
#
# Output: the list of non-compliant paths (empty if compliant).
#

# Extract the inode numbers for all of those directories. In case any is
# a symlink, we want to get the inode of the pointed-to directory, so we
# append '/.' to be sure we get the target directory. Since the symlinks
# can be anyway (/bin -> /usr/bin or /usr/bin -> /bin), we do that for
# all of them.
#
lib_inode=$(stat -c '%i' "${1}/lib/." 2>/dev/null)
bin_inode=$(stat -c '%i' "${1}/bin/." 2>/dev/null)
sbin_inode=$(stat -c '%i' "${1}/sbin/." 2>/dev/null)
usr_lib_inode=$(stat -c '%i' "${1}/usr/lib/." 2>/dev/null)
usr_bin_inode=$(stat -c '%i' "${1}/usr/bin/." 2>/dev/null)
usr_sbin_inode=$(stat -c '%i' "${1}/usr/sbin/." 2>/dev/null)

not_merged_dirs=""
test -z "$lib_inode" || \
	test "$lib_inode" = "$usr_lib_inode" || \
		not_merged_dirs="/lib"
test -z "$bin_inode" || \
	test "$bin_inode" = "$usr_bin_inode" || \
		not_merged_dirs="$not_merged_dirs /bin"
test -z "$sbin_inode" || \
	test "$sbin_inode" = "$usr_sbin_inode" || \
		not_merged_dirs="$not_merged_dirs /sbin"
echo "${not_merged_dirs# }"
