################################################################################
#
# p11-kit
#
################################################################################

P11_KIT_VERSION = 0.23.2
P11_KIT_SITE = http://p11-glue.freedesktop.org/releases
P11_KIT_DEPENDENCIES = host-pkgconf libffi libtasn1
P11_KIT_INSTALL_STAGING = YES
P11_KIT_CONF_OPTS = --disable-static
P11_KIT_CONF_ENV = ac_cv_have_decl_program_invocation_short_name=yes \
	ac_cv_have_decl___progname=no
P11_KIT_LICENSE = BSD-3c
P11_KIT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
