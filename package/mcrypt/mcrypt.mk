################################################################################
#
# mcrypt
#
################################################################################

MCRYPT_VERSION = 2.6.8
MCRYPT_SITE = http://downloads.sourceforge.net/project/mcrypt/MCrypt/$(MCRYPT_VERSION)
MCRYPT_DEPENDENCIES = libmcrypt libmhash \
	$(if $(BR2_PACKAGE_ZLIB),zlib) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	$(TARGET_NLS_DEPENDENCIES)
MCRYPT_CONF_OPTS = --with-libmcrypt-prefix=$(STAGING_DIR)/usr
MCRYPT_LICENSE = GPL-3.0
MCRYPT_LICENSE_FILES = COPYING

# 0001-CVE-2012-4409.patch
MCRYPT_IGNORE_CVES += CVE-2012-4409
# 0002-CVE-2012-4426.patch
MCRYPT_IGNORE_CVES += CVE-2012-4426
# 0003-CVE-2012-4527.patch
MCRYPT_IGNORE_CVES += CVE-2012-4527

$(eval $(autotools-package))
