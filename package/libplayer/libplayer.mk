################################################################################
#
# libplayer
#
################################################################################

LIBPLAYER_VERSION = 2.0.1
LIBPLAYER_SITE = http://libplayer.geexbox.org/releases
LIBPLAYER_SOURCE = libplayer-$(LIBPLAYER_VERSION).tar.bz2
LIBPLAYER_LICENSE = LGPLv2.1+
LIBPLAYER_LICENSE_FILES = COPYING

# When passing the standard buildroot configure arguments, the configure script
# breaks on --target and --host options. Thus we need to define a configure cmd
# ourselves.
define LIBPLAYER_CONFIGURE_CMDS
	(cd $(@D) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		--prefix=/usr \
		--cross-compile \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(LIBPLAYER_CONF_OPTS) \
	)
endef

ifeq ($(BR2_PACKAGE_LIBPLAYER_MPLAYER),y)
LIBPLAYER_DEPENDENCIES += mplayer
LIBPLAYER_CONF_OPTS += --enable-mplayer
else
LIBPLAYER_CONF_OPTS += --disable-mplayer
endif

ifeq ($(BR2_PACKAGE_LIBPLAYER_GSTREAMER),y)
LIBPLAYER_DEPENDENCIES += gstreamer
LIBPLAYER_CONF_OPTS += --enable-gstreamer
else
LIBPLAYER_CONF_OPTS += --disable-gstreamer
endif

$(eval $(autotools-package))
