################################################################################
#
# iqvlinux
#
################################################################################

# The upstream tarball is just named iqvlinux.tar.gz, which we cannot
# use because it doesn't contain a version number. Therefore, the
# download from the upstream site will fail, and fallback to the
# backup mirror, where we have added an iqvlinux-1.2.0.3.tar.gz
# tarball.
IQVLINUX_VERSION = 1.2.0.3
IQVLINUX_SITE = https://downloads.sourceforge.net/project/e1000/iqvlinux/$(IQVLINUX_VERSION)

IQVLINUX_LICENSE = GPL-2.0, BSD-3-Clause
IQVLINUX_LICENSE_FILES = \
	COPYING src/linux/driver/files.txt \
	inc/linux/files.txt inc/files.txt

IQVLINUX_MODULE_MAKE_OPTS = NALDIR=$(@D) KSRC=$(LINUX_DIR) CC=$(TARGET_CC)

IQVLINUX_MODULE_SUBDIRS = src/linux/driver

$(eval $(kernel-module))
$(eval $(generic-package))
