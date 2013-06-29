################################################################################
#
# libtpl
#
################################################################################

LIBTPL_VERSION = 445b4e9f236a48e274eaace31acf56d700da142a
LIBTPL_SITE = http://github.com/troydhanson/tpl/tarball/$(LIBTPL_VERSION)
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
