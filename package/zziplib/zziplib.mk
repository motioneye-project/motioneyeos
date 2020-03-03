################################################################################
#
# zziplib
#
################################################################################

ZZIPLIB_VERSION = 0.13.69
ZZIPLIB_SITE = $(call github,gdraheim,zziplib,v$(ZZIPLIB_VERSION))
ZZIPLIB_LICENSE = LGPL-2.0+ or MPL-1.1
ZZIPLIB_LICENSE_FILES = docs/COPYING.LIB docs/COPYING.MPL docs/copying.htm
ZZIPLIB_INSTALL_STAGING = YES

# 0001-Avoid-memory-leak-from-__zzip_parse_root_directory.patch
# 0002-Avoid-memory-leak-from-__zzip_parse_root_directory-2.patch
# 0003-One-more-free-to-avoid-memory-leak.patch
ZZIPLIB_IGNORE_CVES += CVE-2018-16548

# 0004-Fix-issue-62-Remove-any-components-from-pathnames-of-extracte.patch
ZZIPLIB_IGNORE_CVES += CVE-2018-17828

ZZIPLIB_DEPENDENCIES = host-pkgconf host-python zlib

# zziplib is not python3 friendly, so force the python interpreter
ZZIPLIB_CONF_OPTS = ac_cv_path_PYTHON=$(HOST_DIR)/bin/python2

$(eval $(autotools-package))
