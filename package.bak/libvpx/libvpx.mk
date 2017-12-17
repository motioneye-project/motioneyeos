################################################################################
#
# libvpx
#
################################################################################

LIBVPX_VERSION = 1.6.0
LIBVPX_SOURCE = libvpx-$(LIBVPX_VERSION).tar.bz2
LIBVPX_SITE = http://storage.googleapis.com/downloads.webmproject.org/releases/webm
LIBVPX_LICENSE = BSD-3c
LIBVPX_LICENSE_FILES = LICENSE PATENTS
LIBVPX_INSTALL_STAGING = YES

# ld is being used with cc options. therefore, pretend ld is cc.
LIBVPX_CONF_ENV = \
	LD="$(TARGET_CC)" \
	CROSS=$(GNU_TARGET_NAME)

LIBVPX_CONF_OPTS = \
	--disable-examples \
	--disable-docs \
	--disable-unit-tests

# This is not a true autotools package.  It is based on the ffmpeg build system
define LIBVPX_CONFIGURE_CMDS
	(cd $(LIBVPX_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(LIBVPX_CONF_ENV) \
	./configure \
		--target=generic-gnu \
		--enable-pic \
		--prefix=/usr \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(LIBVPX_CONF_OPTS) \
	)
endef

define LIBVPX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(LIBVPX_MAKE_ENV) $(MAKE) -C $(@D) all
endef

define LIBVPX_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(LIBVPX_MAKE_ENV) $(MAKE) DESTDIR="$(STAGING_DIR)" -C $(@D) install
endef

define LIBVPX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(LIBVPX_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

$(eval $(generic-package))
