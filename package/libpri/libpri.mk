################################################################################
#
# libpri
#
################################################################################

LIBPRI_VERSION = 1.5.0
LIBPRI_SITE = http://downloads.asterisk.org/pub/telephony/libpri/releases

LIBPRI_LICENSE = GPL-2.0 with OpenH323 exception
LIBPRI_LICENSE_FILES = LICENSE README

LIBPRI_DEPENDENCIES = dahdi-linux dahdi-tools
LIBPRI_INSTALL_STAGING = YES

# The Makefile default rule will always try to generate both libraries.
# So we need to explicitly build only what we can.
ifneq ($(BR2_SHARED_LIBS),y)
LIBPRI_LIBS = libpri.a
define LIBPRI_INSTALL_A
	$(INSTALL) -D -m 0644 $(@D)/libpri.a $(1)/usr/lib/libpri.a
endef
endif

ifneq ($(BR2_STATIC_LIBS),y)
LIBPRI_LIBS += libpri.so.1.4
define LIBPRI_INSTALL_SO
	$(INSTALL) -D -m 0644 $(@D)/libpri.so.1.4 $(1)/usr/lib/libpri.so.1.4
	ln -sf libpri.so.1.4 $(1)/usr/lib/libpri.so
endef
endif

LIBPRI_UTILS = pridump pritest rosetest testprilib

define LIBPRI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" -C $(@D) \
		$(LIBPRI_LIBS) $(LIBPRI_UTILS)
endef

define LIBPRI_INSTALL_STAGING_CMDS
	$(call LIBPRI_INSTALL_A,$(STAGING_DIR))
	$(call LIBPRI_INSTALL_SO,$(STAGING_DIR))
	$(INSTALL) -D -m 0644 $(@D)/libpri.h $(STAGING_DIR)/usr/include/libpri.h
endef

define LIBPRI_INSTALL_TARGET_CMDS
	$(foreach u,$(LIBPRI_UTILS),\
		$(INSTALL) -D -m 0755 $(@D)/$(u) $(TARGET_DIR)/usr/sbin/$(u)$(sep))
	$(call LIBPRI_INSTALL_SO,$(TARGET_DIR))
endef

$(eval $(generic-package))
