################################################################################
#
# opkg
#
################################################################################

OPKG_VERSION = 0.3.6
OPKG_SITE = http://downloads.yoctoproject.org/releases/opkg
OPKG_DEPENDENCIES = host-pkgconf libarchive
OPKG_LICENSE = GPL-2.0+
OPKG_LICENSE_FILES = COPYING
OPKG_INSTALL_STAGING = YES
OPKG_CONF_OPTS = --disable-curl
# Populate the conf/ directory
OPKG_AUTORECONF = YES

# Ensure directory for lockfile exists
define OPKG_CREATE_LOCKDIR
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
endef

# The conf/ directory contains symlinks to host automake and libtool provided
# scripts. Don't rely on them being present.
define OPKG_REMOVE_AUTOTOOLS_SYMLINKS
	rm $(@D)/conf/*
endef

OPKG_POST_EXTRACT_HOOKS += OPKG_REMOVE_AUTOTOOLS_SYMLINKS

ifeq ($(BR2_PACKAGE_OPKG_GPG_SIGN),y)
OPKG_CONF_OPTS += --enable-gpg
OPKG_CONF_ENV += \
	ac_cv_path_GPGME_CONFIG=$(STAGING_DIR)/usr/bin/gpgme-config \
	ac_cv_path_GPGERR_CONFIG=$(STAGING_DIR)/usr/bin/gpg-error-config
OPKG_DEPENDENCIES += libgpgme libgpg-error
else
OPKG_CONF_OPTS += --disable-gpg
endif

OPKG_POST_INSTALL_TARGET_HOOKS += OPKG_CREATE_LOCKDIR

$(eval $(autotools-package))
