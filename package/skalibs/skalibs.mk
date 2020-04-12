################################################################################
#
# skalibs
#
################################################################################

SKALIBS_VERSION = 2.9.2.1
SKALIBS_SITE = http://skarnet.org/software/skalibs
SKALIBS_LICENSE = ISC
SKALIBS_LICENSE_FILES = COPYING
SKALIBS_INSTALL_STAGING = YES

SKALIBS_CONF_OPTS = \
	--prefix=/usr \
	--with-default-path=/sbin:/usr/sbin:/bin:/usr/bin \
	--with-sysdep-devurandom=yes \
	$(SHARED_STATIC_LIBS_OPTS)

define SKALIBS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(SKALIBS_CONF_OPTS))
endef

define SKALIBS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SKALIBS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/usr/lib/skalibs
endef

define SKALIBS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_SKALIBS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_SKALIBS_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_SKALIBS_CONF_OPTS))
endef

define HOST_SKALIBS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_SKALIBS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
