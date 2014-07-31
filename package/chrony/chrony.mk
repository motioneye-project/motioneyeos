################################################################################
#
# chrony
#
################################################################################

CHRONY_VERSION = 1.29.1
CHRONY_SITE = http://download.tuxfamily.org/chrony
CHRONY_LICENSE = GPLv2
CHRONY_LICENSE_FILES = COPYING

CHRONY_CONF_OPT = --host-system=Linux --host-machine=$(BR2_ARCH) --prefix=/usr

ifeq ($(BR2_PACKAGE_LIBNSS),y)
CHRONY_DEPENDENCIES += host-pkgconf libnss
else
CHRONY_CONF_OPT += --without-nss
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
CHRONY_DEPENDENCIES += readline
else
CHRONY_CONF_OPT += --disable-readline
endif

ifneq ($(BR2_INET_IPV6),y)
CHRONY_CONF_OPT += --disable-ipv6
endif

define CHRONY_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_CONFIGURE_OPTS) ./configure $(CHRONY_CONF_OPT)
endef

define CHRONY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define CHRONY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
