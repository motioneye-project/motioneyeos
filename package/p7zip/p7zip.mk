################################################################################
#
# p7zip
#
################################################################################

P7ZIP_VERSION = 16.02
P7ZIP_SOURCE = p7zip_$(P7ZIP_VERSION)_src_all.tar.bz2
P7ZIP_SITE = http://downloads.sourceforge.net/project/p7zip/p7zip/$(P7ZIP_VERSION)
P7ZIP_LICENSE = LGPL-2.1+ with unRAR restriction
P7ZIP_LICENSE_FILES = DOC/License.txt

# 0001-CVE-2016-9296.patch
P7ZIP_IGNORE_CVES += CVE-2016-9296
# 0002-CVE-2017-17969.patch
P7ZIP_IGNORE_CVES += CVE-2017-17969
# 0003-CVE-2018-5996.patch
P7ZIP_IGNORE_CVES += CVE-2018-5996

# p7zip buildsystem is a mess: it plays dirty tricks with CFLAGS and
# CXXFLAGS, so we can't pass them. Instead, it accepts ALLFLAGS_C
# and ALLFLAGS_CPP as variables to pass the CFLAGS and CXXFLAGS.
define P7ZIP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" ALLFLAGS_C="$(TARGET_CFLAGS)" \
		CXX="$(TARGET_CXX)" ALLFLAGS_CPP="$(TARGET_CXXFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		-C $(@D) 7zr
endef

define P7ZIP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/7zr $(TARGET_DIR)/usr/bin/7zr
endef

$(eval $(generic-package))
