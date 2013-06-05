################################################################################
#
# crda
#
################################################################################

CRDA_VERSION = 1.1.3
CRDA_SOURCE = crda-$(CRDA_VERSION).tar.bz2
CRDA_SITE = http://wireless.kernel.org/download/crda
CRDA_DEPENDENCIES = host-pkgconf host-python-m2crypto \
	libnl libgcrypt
CRDA_LICENSE = ISC
CRDA_LICENSE_FILES = LICENSE

define CRDA_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) all_noverify -C $(@D)
endef

define CRDA_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) install -C $(@D) DESTDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
