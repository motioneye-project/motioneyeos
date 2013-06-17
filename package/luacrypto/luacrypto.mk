################################################################################
#
# luacrypto
#
################################################################################

LUACRYPTO_VERSION = 0.3.2
LUACRYPTO_SITE = http://github.com/mkottman/luacrypto/tarball/$(LUACRYPTO_VERSION)
LUACRYPTO_LICENSE = MIT
LUACRYPTO_LICENSE_FILES = COPYING
LUACRYPTO_DEPENDENCIES = lua openssl
LUACRYPTO_CONF_OPT = "-DLUA_LIBRARIES=\"$(STAGING_DIR)/usr/lib/liblua.so\""

$(eval $(cmake-package))
