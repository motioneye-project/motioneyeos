################################################################################
#
# midori
#
################################################################################

MIDORI_VERSION_MAJOR = 0.4
MIDORI_VERSION = $(MIDORI_VERSION_MAJOR).6
MIDORI_SOURCE = midori-$(MIDORI_VERSION).tar.bz2
MIDORI_SITE = http://archive.xfce.org/src/apps/midori/$(MIDORI_VERSION_MAJOR)/
MIDORI_LICENSE = LGPLv2.1+
MIDORI_LICENSE_FILES = COPYING
MIDORI_DEPENDENCIES = \
	host-intltool \
	host-pkgconf \
	host-vala \
	host-python \
	libgtk2 \
	libsexy \
	webkit \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifneq ($(BR2_PACKAGE_XORG7),y)
define MIDORI_WITHOUT_X11
	$(SED) "s/check_pkg ('x11')/#check_pkg ('x11')/" $(@D)/wscript
endef
endif

define MIDORI_CONFIGURE_CMDS
	$(MIDORI_WITHOUT_X11)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS)	\
		$(HOST_DIR)/usr/bin/python2 ./waf configure \
		--prefix=/usr			\
		--disable-libnotify		\
       )
endef

define MIDORI_BUILD_CMDS
       (cd $(@D); $(HOST_DIR)/usr/bin/python2 ./waf build -j $(PARALLEL_JOBS))
endef

define MIDORI_INSTALL_TARGET_CMDS
       (cd $(@D); $(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(TARGET_DIR) install)
endef

$(eval $(generic-package))
