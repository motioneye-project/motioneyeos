################################################################################
#
# cpio
#
################################################################################

CPIO_VERSION = 2.11
CPIO_SITE = http://ftp.gnu.org/gnu/cpio
CPIO_LICENSE = GPLv3+
CPIO_LICENSE_FILES = COPYING
CPIO_PATCH = \
	https://projects.archlinux.org/svntogit/packages.git/plain/cpio/trunk/cpio-2.11-stdio.in.patch \
	https://projects.archlinux.org/svntogit/packages.git/plain/cpio/trunk/cpio-2.11-CVE-2014-9112.patch \
	https://projects.archlinux.org/svntogit/packages.git/plain/cpio/trunk/cpio-2.11-testsuite-CVE-2014-9112.patch \
	https://projects.archlinux.org/svntogit/packages.git/plain/cpio/trunk/cpio-2.11-check_for_symlinks-CVE-2015-1197.patch \
	https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-arch/cpio/files/cpio-2.11-stat.patch

# cpio uses argp.h which is not provided by uclibc by default.
# Use the argp-standalone package to provide this but make sure
# the host package does not try to use the host version.
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
CPIO_DEPENDENCIES += argp-standalone
endif

$(eval $(autotools-package))
