################################################################################
#
# jimtcl
#
################################################################################

JIMTCL_VERSION = 0.73
JIMTCL_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/j/jimtcl
JIMTCL_SOURCE = jimtcl_$(JIMTCL_VERSION).orig.tar.bz2
JIMTCL_INSTALL_STAGING = YES
JIMTCL_LICENSE = BSD-2c
JIMTCL_LICENSE_FILES = LICENSE

JIMTCL_HEADERS_TO_INSTALL = \
	jim.h \
	jim-eventloop.h \
	jim-signal.h \
	jim-subcmd.h \
	jim-win32compat.h \
	jim-config.h \

ifeq ($(BR2_PACKAGE_TCL),)
define JIMTCL_LINK_TCLSH
	ln -sf jimsh $(TARGET_DIR)/usr/bin/tclsh
endef
endif

ifeq ($(BR2_PREFER_STATIC_LIB),y)
JIMTCL_SHARED =
JIMTCL_LIB = a
JIMTCL_INSTALL_LIB =
else
JIMTCL_SHARED = --shared
JIMTCL_LIB = so
JIMTCL_INSTALL_LIB = $(INSTALL) -D $(@D)/libjim.$(JIMTCL_LIB) \
		     $(TARGET_DIR)/usr/lib/libjim.$(JIMTCL_LIB)
endif

define JIMTCL_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) CCACHE=none \
		./configure --prefix=/usr \
		$(JIMTCL_SHARED) \
	)
endef

define JIMTCL_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define JIMTCL_INSTALL_STAGING_CMDS
	for i in $(JIMTCL_HEADERS_TO_INSTALL); do \
		cp -a $(@D)/$$i $(STAGING_DIR)/usr/include/ ; \
	done; \
	$(INSTALL) -D $(@D)/libjim.$(JIMTCL_LIB) $(STAGING_DIR)/usr/lib/libjim.$(JIMTCL_LIB)
endef

define JIMTCL_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/jimsh $(TARGET_DIR)/usr/bin/jimsh
	$(JIMTCL_INSTALL_LIB)
	$(JIMTCL_LINK_TCLSH)
endef

$(eval $(generic-package))
