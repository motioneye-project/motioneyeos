################################################################################
#
# zziplib
#
################################################################################

ZZIPLIB_VERSION = 0.13.71
ZZIPLIB_SITE = $(call github,gdraheim,zziplib,v$(ZZIPLIB_VERSION))
ZZIPLIB_LICENSE = LGPL-2.0+ or MPL-1.1
ZZIPLIB_LICENSE_FILES = docs/COPYING.LIB docs/COPYING.MPL docs/copying.htm
ZZIPLIB_INSTALL_STAGING = YES

ZZIPLIB_DEPENDENCIES = host-pkgconf host-python3 zlib

ZZIPLIB_CONF_OPTS = ac_cv_path_PYTHON=$(HOST_DIR)/bin/python3

$(eval $(autotools-package))
