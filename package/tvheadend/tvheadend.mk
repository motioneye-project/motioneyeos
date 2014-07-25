################################################################################
#
# tvheadend
#
################################################################################

TVHEADEND_VERSION = f72733ff08be069620e7247e191d4f0899a2638a
TVHEADEND_SITE = $(call github,tvheadend,tvheadend,$(TVHEADEND_VERSION))
TVHEADEND_LICENSE = GPLv3+
TVHEADEND_LICENSE_FILES = LICENSE.md
TVHEADEND_DEPENDENCIES = host-pkgconf host-python openssl

ifeq ($(BR2_PACKAGE_AVAHI),y)
TVHEADEND_DEPENDENCIES += avahi
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
TVHEADEND_DEPENDENCIES += libiconv
endif

TVHEADEND_DEPENDENCIES += dtv-scan-tables

define TVHEADEND_CONFIGURE_CMDS
	(cd $(@D);				\
	 $(TARGET_CONFIGURE_OPTS)		\
	 $(TARGET_CONFIGURE_ARGS)		\
	 ./configure				\
	 --prefix=/usr				\
	 --arch="$(ARCH)"			\
	 --cpu="$(BR2_GCC_TARGET_CPU)"		\
	 --python="$(HOST_DIR)/usr/bin/python"	\
	 --disable-dvbscan			\
	)
endef

define TVHEADEND_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define TVHEADEND_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

#----------------------------------------------------------------------------
# To run tvheadend, we need:
#  - a startup script, and its config file
#  - a default DB with a tvheadend admin
#  - a non-root user to run as
define TVHEADEND_INSTALL_DB
	$(INSTALL) -D -m 0600 package/tvheadend/accesscontrol.1     \
	              $(TARGET_DIR)/home/tvheadend/.hts/tvheadend/accesscontrol/1
	chmod -R go-rwx $(TARGET_DIR)/home/tvheadend
endef
TVHEADEND_POST_INSTALL_TARGET_HOOKS  = TVHEADEND_INSTALL_DB

define TVHEADEND_INSTALL_INIT_SYSV
	$(INSTALL) -D package/tvheadend/etc.default.tvheadend $(TARGET_DIR)/etc/default/tvheadend
	$(INSTALL) -D package/tvheadend/S99tvheadend          $(TARGET_DIR)/etc/init.d/S99tvheadend
endef

define TVHEADEND_USERS
tvheadend -1 tvheadend -1 * /home/tvheadend - video TVHeadend daemon
endef

$(eval $(generic-package))
