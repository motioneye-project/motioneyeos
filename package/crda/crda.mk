################################################################################
#
# crda
#
################################################################################

CRDA_VERSION = 3.18
CRDA_SOURCE = crda-$(CRDA_VERSION).tar.xz
CRDA_SITE = $(BR2_KERNEL_MIRROR)/software/network/crda
CRDA_DEPENDENCIES = host-pkgconf host-python-pycrypto libnl libgcrypt
CRDA_LICENSE = ISC
CRDA_LICENSE_FILES = LICENSE

define CRDA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) all_noverify -C $(@D)
endef

define CRDA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D) DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
