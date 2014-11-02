################################################################################
#
# sudo
#
################################################################################

SUDO_VERSION = 1.8.10p3
SUDO_SITE = http://www.sudo.ws/sudo/dist
SUDO_LICENSE = ISC BSD-3c
SUDO_LICENSE_FILES = doc/LICENSE
# Ships a non-release libtool that isn't patch-friendly
SUDO_AUTORECONF = YES
SUDO_CONF_OPTS = \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--without-pam \
		--with-env-editor

# mksigname/mksiglist needs to run on build host to generate source files
define SUDO_BUILD_MKSIGNAME_MKSIGLIST_HOST
	$(MAKE) $(HOST_CONFIGURE_OPTS) \
		CPPFLAGS="$(HOST_CPPFLAGS) -I../include -I.." \
		-C $(@D)/compat mksigname mksiglist
endef

SUDO_POST_CONFIGURE_HOOKS += SUDO_BUILD_MKSIGNAME_MKSIGLIST_HOST

define SUDO_PERMISSIONS
	/usr/bin/sudo			 f 4755	0 0 - - - - -
endef

$(eval $(autotools-package))
