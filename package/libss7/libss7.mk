################################################################################
#
# libss7
#
################################################################################

LIBSS7_VERSION = 2.0.0
LIBSS7_SITE = http://downloads.asterisk.org/pub/telephony/libss7/releases

LIBSS7_LICENSE = GPL-2.0
LIBSS7_LICENSE_FILES = LICENSE

LIBSS7_DEPENDENCIES = dahdi-linux dahdi-tools
LIBSS7_INSTALL_STAGING = YES

# The Makefile default rule will always try to generate both libraries.
# So we need to explicitly build only what we can.
ifneq ($(BR2_SHARED_LIBS),y)
LIBSS7_LIBS = libss7.a
define LIBSS7_INSTALL_A
	$(INSTALL) -D -m 0644 $(@D)/libss7.a $(1)/usr/lib/libss7.a
endef
endif

ifneq ($(BR2_STATIC_LIBS),y)
LIBSS7_LIBS += libss7.so.2.0
define LIBSS7_INSTALL_SO
	$(INSTALL) -D -m 0644 $(@D)/libss7.so.2.0 $(1)/usr/lib/libss7.so.2.0
	ln -sf libss7.so.2.0 $(1)/usr/lib/libss7.so
endef
endif

# The Makefile erroneously looks for host headers to decide what utilities
# to build, and thus misses the test utilities. So we explicitly build them
# as they can be useful to validate that the hardware does work.
LIBSS7_UTILS = parser_debug ss7test ss7linktest

define LIBSS7_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(LIBSS7_LIBS) $(LIBSS7_UTILS)
endef

define LIBSS7_INSTALL_STAGING_CMDS
	$(call LIBSS7_INSTALL_A,$(STAGING_DIR))
	$(call LIBSS7_INSTALL_SO,$(STAGING_DIR))
	$(INSTALL) -D -m 0644 $(@D)/libss7.h $(STAGING_DIR)/usr/include/libss7.h
endef

define LIBSS7_INSTALL_TARGET_CMDS
	$(foreach u,$(LIBSS7_UTILS),\
		$(INSTALL) -D -m 0755 $(@D)/$(u) $(TARGET_DIR)/usr/sbin/$(u)$(sep))
	$(call LIBSS7_INSTALL_SO,$(TARGET_DIR))
endef

$(eval $(generic-package))
