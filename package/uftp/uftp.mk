################################################################################
#
# uftp
#
################################################################################

UFTP_VERSION = 4.9.9
UFTP_SITE = http://sourceforge.net/projects/uftp-multicast/files/source-tar
UFTP_DEPENDENCIES = openssl
UFTP_LICENSE = GPL-3.0+
UFTP_LICENSE_FILES = LICENSE.txt

define UFTP_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define UFTP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
