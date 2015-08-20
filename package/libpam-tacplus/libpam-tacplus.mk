################################################################################
#
# libpam-tacplus
#
################################################################################

LIBPAM_TACPLUS_VERSION = 1.3.9
LIBPAM_TACPLUS_SITE = $(call github,jeroennijhof,pam_tacplus,$(LIBPAM_TACPLUS_VERSION))
LIBPAM_TACPLUS_LICENSE = GPLv2+
LIBPAM_TACPLUS_LICENSE_FILES = COPYING
LIBPAM_TACPLUS_DEPENDENCIES = linux-pam
# Fetching from github, we need to generate the configure script
LIBPAM_TACPLUS_AUTORECONF = YES
LIBPAM_TACPLUS_AUTORECONF_OPTS = -I m4
LIBPAM_TACPLUS_INSTALL_STAGING = YES
LIBPAM_TACPLUS_CONF_ENV = \
	ax_cv_check_cflags___fstack_protector_all=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)
LIBPAM_TACPLUS_CONF_OPTS = \
	--enable-pamdir=/lib/security

$(eval $(autotools-package))
