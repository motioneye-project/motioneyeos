################################################################################
#
# moarvm
#
################################################################################

MOARVM_VERSION = 2020.01.1
MOARVM_SITE = http://moarvm.com/releases
MOARVM_SOURCE = MoarVM-$(MOARVM_VERSION).tar.gz
MOARVM_LICENSE = Artistic-2.0
MOARVM_LICENSE_FILES = Artistic2.txt
MOARVM_INSTALL_STAGING = YES
MOARVM_DEPENDENCIES = host-pkgconf libuv libtommath libatomic_ops

MOARVM_CONF_OPTS = \
	--build=$(GNU_HOST_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--ar="$(TARGET_AR)" \
	--cc="$(TARGET_CC)" \
	--ld="$(TARGET_CC)" \
	--prefix="/usr" \
	--pkgconfig=$(PKG_CONFIG_HOST_BINARY) \
	--has-libuv \
	--has-libtommath \
	--has-libatomic

ifeq ($(BR2_PACKAGE_LIBFFI),y)
MOARVM_CONF_OPTS += --has-libffi
MOARVM_DEPENDENCIES += libffi
endif

ifeq ($(BR2_ENDIAN),"BIG")
MOARVM_CONF_OPTS += --big-endian
endif

define MOARVM_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) perl Configure.pl $(MOARVM_CONF_OPTS))
endef

define MOARVM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MOARVM_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define MOARVM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
