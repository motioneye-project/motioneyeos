#############################################################
#
# tvheadend
#
##############################################################

TVHEADEND_VERSION           = v3.5
TVHEADEND_SITE              = http://github.com/tvheadend/tvheadend/tarball/$(TVHEADEND_VERSION)
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

#----------------------------------------------------------------------------
# To run tvheadend, we need:
#  - a startup script, and its config file
#  - a default DB with a tvheadend admin
define TVHEADEND_INSTALL_DB
	$(INSTALL) -D package/tvheadend/accesscontrol.1     \
	              $(TARGET_DIR)/root/.hts/tvheadend/accesscontrol/1
endef
TVHEADEND_POST_INSTALL_TARGET_HOOKS  = TVHEADEND_INSTALL_DB

define TVHEADEND_INSTALL_INIT_SYSV
	$(INSTALL) -D package/tvheadend/etc.default.tvheadend $(TARGET_DIR)/etc/default/tvheadend
	$(INSTALL) -D package/tvheadend/S99tvheadend          $(TARGET_DIR)/etc/init.d/S99tvheadend
endef

#----------------------------------------------------------------------------
# tvheadend is not an autotools-based package, but it is possible to
# call its ./configure script as if it were an autotools one.
$(eval $(autotools-package))
