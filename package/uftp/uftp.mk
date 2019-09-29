################################################################################
#
# uftp
#
################################################################################

UFTP_VERSION = 4.10
UFTP_SITE = http://sourceforge.net/projects/uftp-multicast/files/source-tar
UFTP_LICENSE = GPL-3.0+
UFTP_LICENSE_FILES = LICENSE.txt

ifeq ($(BR2_PACKAGE_OPENSSL),y)
UFTP_DEPENDENCIES += host-pkgconf openssl
UFTP_MAKE_OPTS += CRYPT_LIB="`$(PKG_CONFIG_HOST_BINARY) --libs libcrypto`"
else
UFTP_MAKE_OPTS += NO_ENCRYPTION=1
endif

define UFTP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(UFTP_MAKE_OPTS)
endef

define UFTP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(UFTP_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
