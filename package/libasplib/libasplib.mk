################################################################################
#
# libasplib
#
################################################################################

LIBASPLIB_VERSION = f7219142e790a329b002a94f3db943abcb183739
LIBASPLIB_SITE = $(call github,AchimTuran,asplib,$(LIBASPLIB_VERSION))
LIBASPLIB_LICENSE = GPLv3+
LIBASPLIB_LICENSE_FILES = LICENSE
LIBASPLIB_INSTALL_STAGING = YES

$(eval $(cmake-package))
