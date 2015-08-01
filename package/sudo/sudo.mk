################################################################################
#
# sudo
#
################################################################################

SUDO_VERSION = 1.8.14p3
SUDO_SITE = http://www.sudo.ws/sudo/dist
SUDO_LICENSE = ISC BSD-3c
SUDO_LICENSE_FILES = doc/LICENSE
# This is to avoid sudo's make install from chown()ing files which fails
SUDO_INSTALL_TARGET_OPTS = INSTALL_OWNER="" DESTDIR="$(TARGET_DIR)" install
SUDO_CONF_OPTS = \
	--without-lecture \
	--without-sendmail \
	--without-umask \
	--with-logging=syslog \
	--without-interfaces \
	--with-env-editor

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define SUDO_INSTALL_PAM_CONF
	$(INSTALL) -D -m 0644 package/sudo/sudo.pam $(TARGET_DIR)/etc/pam.d/sudo
endef

SUDO_DEPENDENCIES += linux-pam
SUDO_CONF_OPTS += --with-pam
SUDO_POST_INSTALL_TARGET_HOOKS += SUDO_INSTALL_PAM_CONF
else
SUDO_CONF_OPTS += --without-pam
endif

# mksigname/mksiglist needs to run on build host to generate source files
define SUDO_BUILD_MKSIGNAME_MKSIGLIST_HOST
	$(MAKE) $(HOST_CONFIGURE_OPTS) \
		CPPFLAGS="$(HOST_CPPFLAGS) -I../../include -I../.." \
		-C $(@D)/lib/util mksigname mksiglist
endef

SUDO_POST_CONFIGURE_HOOKS += SUDO_BUILD_MKSIGNAME_MKSIGLIST_HOST

define SUDO_PERMISSIONS
	/usr/bin/sudo f 4755 0 0 - - - - -
endef

$(eval $(autotools-package))
