################################################################################
#
# libpam-radius-auth
#
################################################################################

LIBPAM_RADIUS_AUTH_VERSION = 1.4.0
LIBPAM_RADIUS_AUTH_SITE = ftp://ftp.freeradius.org/pub/radius
LIBPAM_RADIUS_AUTH_SOURCE = pam_radius-$(LIBPAM_RADIUS_AUTH_VERSION).tar.gz
LIBPAM_RADIUS_AUTH_DEPENDENCIES = linux-pam
LIBPAM_RADIUS_AUTH_INSTALL_STAGING = YES
LIBPAM_RADIUS_AUTH_LICENSE = GPL-2.0+
LIBPAM_RADIUS_AUTH_LICENSE_FILES = LICENSE
# While autoconf is used for configuration, the Makefile is
# hand-written, so we need to pass CC, LD, CFLAGS at build time.
LIBPAM_RADIUS_AUTH_MAKE_ENV = $(TARGET_CONFIGURE_OPTS)

define LIBPAM_RADIUS_AUTH_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/lib/security/
	cp -dpfr $(@D)/pam_radius_auth.so* $(STAGING_DIR)/lib/security/
endef

define LIBPAM_RADIUS_AUTH_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/security/
	cp -dpfr $(@D)/pam_radius_auth.so* $(TARGET_DIR)/lib/security/
endef

$(eval $(autotools-package))
