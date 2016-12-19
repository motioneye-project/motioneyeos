################################################################################
#
# s6
#
################################################################################

S6_VERSION = 2.4.0.0
S6_SITE = http://skarnet.org/software/s6
S6_LICENSE = ISC
S6_LICENSE_FILES = COPYING
S6_INSTALL_STAGING = YES
S6_DEPENDENCIES = execline

S6_CONF_OPTS = \
	--prefix=/usr \
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/usr/include \
	--with-dynlib=$(STAGING_DIR)/usr/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/execline \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_CONF_OPTS))
endef

define S6_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/s6
endef

S6_POST_INSTALL_TARGET_HOOKS += S6_REMOVE_STATIC_LIB_DIR

define S6_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_S6_DEPENDENCIES = host-execline

HOST_S6_CONF_OPTS = \
	--prefix=$(HOST_DIR)/usr \
	--with-sysdeps=$(HOST_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/usr/include \
	--with-dynlib=$(HOST_DIR)/usr/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_CONF_OPTS))
endef

define HOST_S6_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-include
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
