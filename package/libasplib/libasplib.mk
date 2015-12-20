################################################################################
#
# libasplib
#
################################################################################

LIBASPLIB_VERSION = 2fac1bf34efd210b95949fddcbd4a12d287d3e82
LIBASPLIB_SITE = $(call github,kodi-adsp,asplib,$(LIBASPLIB_VERSION))
LIBASPLIB_LICENSE = GPLv3+
LIBASPLIB_LICENSE_FILES = LICENSE
LIBASPLIB_INSTALL_STAGING = YES

$(eval $(cmake-package))
