################################################################################
#
# prosody
#
################################################################################

PROSODY_VERSION = 0.11.2
PROSODY_SITE = https://prosody.im/downloads/source
PROSODY_LICENSE = MIT
PROSODY_LICENSE_FILES = COPYING
PROSODY_DEPENDENCIES = host-luainterpreter luainterpreter libidn openssl

PROSODY_CFLAGS = $(TARGET_CFLAGS) -fPIC -std=c99 \
	$(if BR2_TOOLCHAIN_USES_MUSL,-DWITHOUT_MALLINFO)

PROSODY_CONF_OPTS = \
	--with-lua-bin=$(HOST_DIR)/bin \
	--with-lua=$(STAGING_DIR)/usr \
	--lua-version=$(LUAINTERPRETER_ABIVER) \
	--c-compiler=$(TARGET_CC) \
	--cflags="$(PROSODY_CFLAGS)" \
	--linker=$(TARGET_CC) \
	--ldflags="$(TARGET_LDFLAGS) -shared" \
	--sysconfdir=/etc/prosody \
	--prefix=/usr

ifeq ($(BR2_PACKAGE_LUAJIT),y)
PROSODY_CONF_OPTS += --runwith=luajit
endif

define PROSODY_CONFIGURE_CMDS
	cd $(@D) && \
		$(TARGET_CONFIGURE_OPTS) \
		./configure $(PROSODY_CONF_OPTS)
endef

define PROSODY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define PROSODY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

define PROSODY_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/prosody/S50prosody \
		$(TARGET_DIR)/etc/init.d/S50prosody
endef

define PROSODY_USERS
	prosody -1 prosody -1 * - - - Prosody user
endef

# make install installs a Makefile and meta data to generate certs
define PROSODY_REMOVE_CERT_GENERATOR
	rm -f $(TARGET_DIR)/etc/prosody/certs/Makefile
	rm -f $(TARGET_DIR)/etc/prosody/certs/*.cnf
endef

PROSODY_POST_INSTALL_TARGET_HOOKS += PROSODY_REMOVE_CERT_GENERATOR

$(eval $(generic-package))
