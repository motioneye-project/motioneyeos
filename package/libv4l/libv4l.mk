#############################################################
#
# libv4l
#
#############################################################
LIBV4L_VERSION = 0.8.5
LIBV4L_SOURCE = v4l-utils-$(LIBV4L_VERSION).tar.bz2
LIBV4L_SITE = http://linuxtv.org/downloads/v4l-utils/
LIBV4L_INSTALL_STAGING = YES
LIBV4L_MAKE_OPTS = PREFIX=/usr
LIBV4L_DEPENDENCIES = jpeg

LIBV4L_DIRS_y += lib
LIBV4L_DIRS_$(BR2_PACKAGE_LIBV4L_DECODE_TM6000)	+= utils/decode_tm6000
LIBV4L_DIRS_$(BR2_PACKAGE_LIBV4L_IR_KEYTABLE)	+= utils/keytable
LIBV4L_DIRS_$(BR2_PACKAGE_LIBV4L_V4L2_COMPLIANCE) += utils/v4l2-compliance
LIBV4L_DIRS_$(BR2_PACKAGE_LIBV4L_V4L2_CTL)	+= utils/v4l2-ctl
LIBV4L_DIRS_$(BR2_PACKAGE_LIBV4L_V4L2_DBG)	+= utils/v4l2-dbg

ifeq ($(BR2_PREFER_STATIC_LIB),y)
	LIBV4L_MAKE_OPTS += LINKTYPE=static
endif

define LIBV4L_BUILD_CMDS
	for i in $(LIBV4L_DIRS_y); do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$$i \
			$(LIBV4L_MAKE_OPTS); done
endef

define LIBV4L_INSTALL_STAGING_CMDS
	for i in $(LIBV4L_DIRS_y); do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$$i \
			DESTDIR=$(STAGING_DIR) $(LIBV4L_MAKE_OPTS) install; done
endef

define LIBV4L_INSTALL_TARGET_CMDS
	for i in $(LIBV4L_DIRS_y); do \
		$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$$i \
			DESTDIR=$(TARGET_DIR) $(LIBV4L_MAKE_OPTS) install; done
endef

$(eval $(generic-package))

