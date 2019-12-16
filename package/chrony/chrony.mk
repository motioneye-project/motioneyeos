################################################################################
#
# chrony
#
################################################################################

CHRONY_VERSION = 3.5
CHRONY_SITE = http://download.tuxfamily.org/chrony
CHRONY_LICENSE = GPL-2.0
CHRONY_LICENSE_FILES = COPYING

CHRONY_CONF_OPTS = \
	--host-system=Linux \
	--host-machine=$(BR2_ARCH) \
	--prefix=/usr \
	--without-readline \
	--without-tomcrypt \
	$(if $(BR2_PACKAGE_CHRONY_DEBUG_LOGGING),--enable-debug,--disable-debug)

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

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
CHRONY_CONF_OPTS += --enable-scfilter
CHRONY_DEPENDENCIES += libseccomp
else
CHRONY_CONF_OPTS += --without-seccomp
endif

ifeq ($(BR2_PACKAGE_LIBEDIT),y)
CHRONY_DEPENDENCIES += libedit
else
CHRONY_CONF_OPTS += --without-editline --disable-readline
endif

# If pps-tools is available, build it before so the package can use it
# (HAVE_SYS_TIMEPPS_H).
ifeq ($(BR2_PACKAGE_PPS_TOOLS),y)
CHRONY_DEPENDENCIES += pps-tools
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
endef

$(eval $(generic-package))
