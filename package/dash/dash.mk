################################################################################
#
# dash
#
################################################################################

DASH_VERSION = 0.5.10.2
DASH_SITE = http://gondor.apana.org.au/~herbert/dash/files
DASH_LICENSE = BSD-3-Clause, GPL-2.0+ (mksignames.c)
DASH_LICENSE_FILES = COPYING

# dash does not build in parallel
DASH_MAKE = $(MAKE1)

ifeq ($(BR2_PACKAGE_LIBEDIT),y)
DASH_DEPENDENCIES += libedit host-pkgconf
DASH_CONF_OPTS += --with-libedit
DASH_CONF_ENV += LIBS=`pkg-config --libs libedit`

# Enable line editing, Emacs style
define DASH_INSTALL_PROFILE
	mkdir -p $(TARGET_DIR)/etc/profile.d
	echo 'set -E' > $(TARGET_DIR)/etc/profile.d/dash.sh
endef
DASH_POST_INSTALL_TARGET_HOOKS += DASH_INSTALL_PROFILE
else
DASH_CONF_OPTS += --without-libedit
endif

define DASH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/dash $(TARGET_DIR)/bin/dash
endef

# Add /bin/dash to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define DASH_ADD_DASH_TO_SHELLS
	grep -qsE '^/bin/dash$$' $(TARGET_DIR)/etc/shells \
		|| echo "/bin/dash" >> $(TARGET_DIR)/etc/shells
endef
DASH_TARGET_FINALIZE_HOOKS += DASH_ADD_DASH_TO_SHELLS

$(eval $(autotools-package))
