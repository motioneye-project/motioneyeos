################################################################################
#
# zziplib
#
################################################################################

ZZIPLIB_VERSION = v0.13.69
ZZIPLIB_SITE = $(call github,gdraheim,zziplib,$(ZZIPLIB_VERSION))
ZZIPLIB_LICENSE = LGPL-2.0+ or MPL-1.1
ZZIPLIB_LICENSE_FILES = docs/COPYING.LIB docs/COPYING.MPL docs/copying.htm
ZZIPLIB_INSTALL_STAGING = YES

ZZIPLIB_DEPENDENCIES = host-pkgconf host-python zlib

# zziplib is not python3 friendly, so force the python interpreter
ZZIPLIB_CONF_OPTS = ac_cv_path_PYTHON=$(HOST_DIR)/bin/python2

$(eval $(autotools-package))
