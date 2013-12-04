################################################################################
#
# tvheadend
#
################################################################################

TVHEADEND_VERSION           = c7d0335eb10d02b780423bef8e7c740e422fff13
TVHEADEND_SITE              = git://github.com/tvheadend/tvheadend.git
TVHEADEND_LICENSE           = GPLv3+
TVHEADEND_LICENSE_FILES     = LICENSE
TVHEADEND_DEPENDENCIES      = host-pkgconf host-python openssl

ifeq ($(BR2_PACKAGE_AVAHI),y)
TVHEADEND_DEPENDENCIES     += avahi
endif

#----------------------------------------------------------------------------
# tvheadend is a little smuggler and thief! ;-)
# During the ./configure, it downloads some files from the dvb-apps
# package, so it has a list of pre-scanned tunner configurations.
# For buildroot, we add a patch that avoids doing that, but uses the
# scan files installed by the dvb-apps package
TVHEADEND_DEPENDENCIES     += dvb-apps

define TVHEADEND_CONFIGURE_CMDS
	(cd $(@D);				\
	 $(TARGET_CONFIGURE_OPTS)		\
	 $(TARGET_CONFIGURE_ARGS)		\
	 ./configure				\
	 --prefix=/usr				\
	 --cc="$(TARGET_CC)"			\
	 --cflags="$(TARGET_CFLAGS)"		\
	 --arch="$(ARCH)"			\
	 --cpu="$(BR2_GCC_TARGET_CPU)"		\
	 --python="$(HOST_DIR)/usr/bin/python"	\
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
