#############################################################
#
# libv4l
#
#############################################################
LIBV4L_VERSION = 0.8.3
LIBV4L_SOURCE = v4l-utils-$(LIBV4L_VERSION).tar.bz2
LIBV4L_SITE = http://linuxtv.org/downloads/v4l-utils/
LIBV4L_INSTALL_STAGING = YES
LIBV4L_MAKE_OPTS = PREFIX=/usr

ifeq ($(BR2_PREFER_STATIC_LIB),y)
	LIBV4L_MAKE_OPTS += LINKTYPE=static
endif

define LIBV4L_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/lib $(LIBV4L_MAKE_OPTS)
endef

define LIBV4L_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D)/lib DESTDIR=$(STAGING_DIR) $(LIBV4L_MAKE_OPTS) install
endef

define LIBV4L_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D)/lib DESTDIR=$(TARGET_DIR) $(LIBV4L_MAKE_OPTS) install
endef

$(eval $(call GENTARGETS,package,libv4l))

