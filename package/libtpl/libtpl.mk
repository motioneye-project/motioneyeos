################################################################################
#
# libtpl
#
################################################################################

LIBTPL_VERSION = 1.6.1
LIBTPL_SITE = $(call github,troydhanson,tpl,v$(LIBTPL_VERSION))
LIBTPL_INSTALL_STAGING = YES
LIBTPL_LICENSE = BSD-like
LIBTPL_LICENSE_FILES = LICENSE

LIBTPL_AUTORECONF = YES

define LIBTPL_CREATE_MISSING_FILES
	touch $(@D)/NEWS $(@D)/AUTHORS $(@D)/ChangeLog $(@D)/COPYING
endef
LIBTPL_POST_EXTRACT_HOOKS += LIBTPL_CREATE_MISSING_FILES

$(eval $(autotools-package))
