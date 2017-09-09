################################################################################
#
# execline
#
################################################################################

EXECLINE_VERSION = 2.3.0.2
EXECLINE_SITE = http://skarnet.org/software/execline
EXECLINE_LICENSE = ISC
EXECLINE_LICENSE_FILES = COPYING
EXECLINE_INSTALL_STAGING = YES
EXECLINE_DEPENDENCIES = skalibs

EXECLINE_CONF_OPTS = \
	--prefix=/usr \
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/usr/include \
	--with-dynlib=$(STAGING_DIR)/usr/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define EXECLINE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(EXECLINE_CONF_OPTS))
endef

define EXECLINE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define EXECLINE_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/execline
endef

EXECLINE_POST_INSTALL_TARGET_HOOKS += EXECLINE_REMOVE_STATIC_LIB_DIR

define EXECLINE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define EXECLINE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_EXECLINE_DEPENDENCIES = host-skalibs

# Set --shebangdir to /usr/bin, as this value is used by the host variant of
# s6-rc when generating execline scripts for the target.
HOST_EXECLINE_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--shebangdir=/usr/bin \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_EXECLINE_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_EXECLINE_CONF_OPTS))
endef

define HOST_EXECLINE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_EXECLINE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
