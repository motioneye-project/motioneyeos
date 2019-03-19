################################################################################
#
# uftp
#
################################################################################

UFTP_VERSION = 4.9.9
UFTP_SITE = http://sourceforge.net/projects/uftp-multicast/files/source-tar
UFTP_DEPENDENCIES = host-pkgconf openssl
UFTP_LICENSE = GPL-3.0+
UFTP_LICENSE_FILES = LICENSE.txt

UFTP_MAKE_OPTS = CRYPT_LIB="`$(PKG_CONFIG_HOST_BINARY) --libs libssl`"

define UFTP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(UFTP_MAKE_OPTS)
endef

define UFTP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(UFTP_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
