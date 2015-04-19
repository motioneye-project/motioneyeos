################################################################################
#
# chrony
#
################################################################################

CHRONY_VERSION = 1.31
CHRONY_SITE = http://download.tuxfamily.org/chrony
CHRONY_LICENSE = GPLv2
CHRONY_LICENSE_FILES = COPYING

CHRONY_CONF_OPTS = --host-system=Linux --host-machine=$(BR2_ARCH) --prefix=/usr

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

# Ditch the doc build, needs makeinfo and we don't need them
define CHRONY_DISABLE_DOCS
	$(SED) 's/chronyc chrony.txt/chronyc/' $(@D)/Makefile.in
endef
CHRONY_POST_PATCH_HOOKS += CHRONY_DISABLE_DOCS

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

$(eval $(generic-package))
