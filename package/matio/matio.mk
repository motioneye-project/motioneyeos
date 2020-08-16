################################################################################
#
# matio
#
################################################################################

MATIO_VERSION = 1.5.17
MATIO_SITE = http://downloads.sourceforge.net/project/matio/matio/$(MATIO_VERSION)
MATIO_LICENSE = BSD-2-Clause
MATIO_LICENSE_FILES = COPYING
MATIO_DEPENDENCIES = zlib
MATIO_INSTALL_STAGING = YES

# 0001-Avoid-uninitialized-memory.patch
MATIO_IGNORE_CVES += CVE-2019-17533
# 0002-Fix-illegal-memory-access.patch
MATIO_IGNORE_CVES += CVE-2019-20017 CVE-2019-20020
# 0003-Fix-illegal-memory-access.patch
MATIO_IGNORE_CVES += CVE-2019-20017 CVE-2019-20018
# 0004-Fix-memory-leak.patch
MATIO_IGNORE_CVES += CVE-2019-20052

# va_copy()
MATIO_CONF_ENV = ac_cv_va_copy=yes

# mat73 require hdf5 (not available), extented-sparse take 2KB
MATIO_CONF_OPTS = --disable-mat73 --enable-extended-sparse

$(eval $(autotools-package))
