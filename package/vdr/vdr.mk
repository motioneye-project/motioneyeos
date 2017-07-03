################################################################################
#
# vdr
#
################################################################################

VDR_VERSION = 2.3.5
VDR_SOURCE = vdr-$(VDR_VERSION).tar.bz2
VDR_SITE = ftp://ftp.tvdr.de/vdr/Developer
VDR_LICENSE = GPL-2.0+
VDR_LICENSE_FILES = COPYING
VDR_INSTALL_STAGING = YES
VDR_DEPENDENCIES = \
	freetype \
	fontconfig \
	jpeg \
	libcap \
	$(TARGET_NLS_DEPENDENCIES)

VDR_INCLUDE_DIRS = -I$(STAGING_DIR)/usr/include/freetype2
VDR_MAKE_FLAGS = \
	NO_KBD=yes \
	PLUGINLIBDIR=/usr/lib/vdr \
	PREFIX=/usr \
	VIDEODIR=/var/lib/vdr
VDR_LDFLAGS = $(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LIBFRIBIDI),y)
VDR_DEPENDENCIES += libfribidi
VDR_INCLUDE_DIRS += -I$(STAGING_DIR)/usr/include/fribidi
VDR_LDFLAGS += -lfribidi
VDR_MAKE_FLAGS += BIDI=1
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
VDR_DEPENDENCIES += libiconv
VDR_LDFLAGS += -liconv
endif

VDR_MAKE_ENV = \
	INCLUDES="$(VDR_INCLUDE_DIRS)" \
	LDFLAGS="$(VDR_LDFLAGS)" \
	$(VDR_MAKE_FLAGS)

define VDR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		vdr vdr.pc include-dir
endef

define VDR_INSTALL_STAGING_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		DESTDIR=$(STAGING_DIR) \
		install-dirs install-bin install-conf install-includes \
		install-pc
endef

define VDR_INSTALL_TARGET_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) $(VDR_MAKE_ENV) \
		DESTDIR=$(TARGET_DIR) \
		install-dirs install-bin install-conf
endef

$(eval $(generic-package))
