################################################################################
#
# libhttpparser
#
################################################################################

LIBHTTPPARSER_VERSION = v2.5.0
LIBHTTPPARSER_SITE = $(call github,joyent,http-parser,$(LIBHTTPPARSER_VERSION))
LIBHTTPPARSER_INSTALL_STAGING = YES
LIBHTTPPARSER_LICENSE = MIT
LIBHTTPPARSER_LICENSE_FILES = LICENSE-MIT

define LIBHTTPPARSER_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) library package
endef

define LIBHTTPPARSER_INSTALL_STAGING_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) PREFIX=$(STAGING_DIR)/usr install
	$(INSTALL) -D -m 0644 $(@D)/libhttp_parser.a $(STAGING_DIR)/usr/lib/libhttp_parser.a
endef

define LIBHTTPPARSER_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) PREFIX=$(TARGET_DIR)/usr install
endef

$(eval $(generic-package))
