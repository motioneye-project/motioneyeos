################################################################################
#
# p11-kit
#
################################################################################

P11_KIT_VERSION = 0.23.16.1
P11_KIT_SITE = https://github.com/p11-glue/p11-kit/releases/download/$(P11_KIT_VERSION)
P11_KIT_DEPENDENCIES = host-pkgconf libffi libtasn1
P11_KIT_INSTALL_STAGING = YES
P11_KIT_CONF_OPTS = --disable-static
P11_KIT_CONF_ENV = ac_cv_have_decl_program_invocation_short_name=yes \
	ac_cv_have_decl___progname=no
P11_KIT_LICENSE = BSD-3-Clause
P11_KIT_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_CA_CERTIFICATES),y)
P11_KIT_CONF_OPTS += --with-trust-paths=/etc/ssl/certs/ca-certificates.crt
else
P11_KIT_CONF_OPTS += --without-trust-paths
endif

$(eval $(autotools-package))
