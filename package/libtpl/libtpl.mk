################################################################################
#
# libtpl
#
################################################################################

LIBTPL_VERSION = 6df007e450cbee7d7a4896d3538128c5370b1c61
LIBTPL_SITE = $(call github,troydhanson,tpl,$(LIBTPL_VERSION))
LIBTPL_INSTALL_STAGING = YES
LIBTPL_LICENSE = BSD-like
LIBTPL_LICENSE_FILES = LICENSE

LIBTPL_AUTORECONF = YES
LIBTPL_AUTORECONF_OPT = --install --force

define LIBTPL_CREATE_MISSING_FILES
	touch $(@D)/NEWS $(@D)/AUTHORS $(@D)/ChangeLog $(@D)/COPYING
endef
LIBTPL_POST_EXTRACT_HOOKS += LIBTPL_CREATE_MISSING_FILES

$(eval $(autotools-package))
