################################################################################
#
# chrony
#
################################################################################

CHRONY_VERSION = 2.4
CHRONY_SITE = http://download.tuxfamily.org/chrony
CHRONY_LICENSE = GPLv2
CHRONY_LICENSE_FILES = COPYING

CHRONY_CONF_OPTS = \
	--host-system=Linux \
	--host-machine=$(BR2_ARCH) \
	--prefix=/usr \
	--without-seccomp \
	--without-tomcrypt

ifeq ($(BR2_PACKAGE_LIBCAP),y)
CHRONY_DEPENDENCIES += libcap
else
CHRONY_CONF_OPTS += --without-libcap
endif

ifeq ($(BR2_PACKAGE_LIBNSS),y)
CHRONY_DEPENDENCIES += host-pkgconf libnss
else
CHRONY_CONF_OPTS += --without-nss
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
CHRONY_DEPENDENCIES += readline
else
CHRONY_CONF_OPTS += --disable-readline
endif

define CHRONY_CONFIGURE_CMDS
	cd $(@D) && $(TARGET_CONFIGURE_OPTS) ./configure $(CHRONY_CONF_OPTS)
endef

define CHRONY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define CHRONY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

define CHRONY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/chrony/S49chrony $(TARGET_DIR)/etc/init.d/S49chrony
endef

define CHRONY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/chrony/chrony.service \
		$(TARGET_DIR)/usr/lib/systemd/system/chrony.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/chrony.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/chrony.service
endef

$(eval $(generic-package))
