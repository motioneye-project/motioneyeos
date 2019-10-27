################################################################################
#
# mdevd
#
################################################################################

MDEVD_VERSION = 0.1.1.1
MDEVD_SITE = http://skarnet.org/software/mdevd
MDEVD_LICENSE = ISC
MDEVD_LICENSE_FILES = COPYING
MDEVD_INSTALL_STAGING = YES
MDEVD_DEPENDENCIES = skalibs

MDEVD_CONF_OPTS = \
	--prefix=/usr \
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/usr/include \
	--with-dynlib=$(STAGING_DIR)/usr/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define MDEVD_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(MDEVD_CONF_OPTS))
endef

define MDEVD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MDEVD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define MDEVD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
