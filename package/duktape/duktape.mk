################################################################################
#
# duktape
#
################################################################################

DUKTAPE_VERSION = v2.3.0
DUKTAPE_SITE = $(call github,svaarala,duktape-releases,$(DUKTAPE_VERSION))
DUKTAPE_LICENSE = MIT
DUKTAPE_LICENSE_FILES = LICENSE.txt
DUKTAPE_INSTALL_STAGING = YES

define DUKTAPE_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -f Makefile.sharedlibrary
endef

define DUKTAPE_INSTALL_STAGING_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -f Makefile.sharedlibrary \
		INSTALL_PREFIX=$(STAGING_DIR)/usr install
endef

define DUKTAPE_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -f Makefile.sharedlibrary \
		INSTALL_PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
