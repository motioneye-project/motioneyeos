################################################################################
#
# dhcpcd
#
################################################################################

DHCPCD_VERSION = 6.8.1
DHCPCD_SOURCE = dhcpcd-$(DHCPCD_VERSION).tar.bz2
DHCPCD_SITE = http://roy.marples.name/downloads/dhcpcd
DHCPCD_DEPENDENCIES = host-pkgconf
DHCPCD_LICENSE = BSD-2c

ifeq ($(BR2_STATIC_LIBS),y)
DHCPCD_CONFIG_OPTS += --enable-static
endif

ifeq ($(BR2_USE_MMU),)
DHCPCD_CONFIG_OPTS += --disable-fork
endif

define DHCPCD_CONFIGURE_CMDS
	(cd $(@D); \
	$(TARGET_CONFIGURE_OPTS) ./configure \
		--os=linux \
		$(DHCPCD_CONFIG_OPTS) )
endef

define DHCPCD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-C $(@D) all
endef

define DHCPCD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install DESTDIR=$(TARGET_DIR)
endef

# NOTE: Even though this package has a configure script, it is not generated
# using the autotools, so we have to use the generic package infrastructure.

$(eval $(generic-package))
