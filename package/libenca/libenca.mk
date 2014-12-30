################################################################################
#
# libenca
#
################################################################################

LIBENCA_VERSION = 1.16
LIBENCA_SITE = $(call github,nijel,enca,$(LIBENCA_VERSION))
LIBENCA_INSTALL_STAGING = YES
LIBENCA_LICENSE = GPLv2
LIBENCA_LICENSE_FILES = COPYING
LIBENCA_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

LIBENCA_CONF_ENV += \
	ac_cv_file__dev_random=yes \
	ac_cv_file__dev_urandom=yes \
	ac_cv_file__dev_arandom=no \
	ac_cv_file__dev_srandom=no

define LIBENCA_MAKE_HOST_TOOL
	$(MAKE) -C $(@D)/tools $(HOST_CONFIGURE_OPTS) make_hash
endef

LIBENCA_PRE_BUILD_HOOKS += LIBENCA_MAKE_HOST_TOOL

$(eval $(autotools-package))
