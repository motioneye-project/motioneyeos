################################################################################
#
# jitterentropy-library
#
################################################################################

JITTERENTROPY_LIBRARY_VERSION = 2.2.0
JITTERENTROPY_LIBRARY_SITE = $(call github,smuellerDD,$(JITTERENTROPY_LIBRARY_NAME),v$(JITTERENTROPY_LIBRARY_VERSION))
JITTERENTROPY_LIBRARY_LICENSE = GPL-2.0 or BSD-3-Clause
JITTERENTROPY_LIBRARY_LICENSE_FILES = COPYING COPYING.bsd COPYING.gplv2
JITTERENTROPY_LIBRARY_INSTALL_STAGING = YES

define JITTERENTROPY_LIBRARY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define JITTERENTROPY_LIBRARY_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) INSTALL_STRIP="install" PREFIX=/usr install
endef

define JITTERENTROPY_LIBRARY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) INSTALL_STRIP="install" PREFIX=/usr install
endef

$(eval $(generic-package))
