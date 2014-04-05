################################################################################
#
# xbmc-pvr-addons
#
################################################################################

# This cset is on the branch 'frodo'
# When XBMC is updated, then this should be updated to the corresponding branch
XBMC_PVR_ADDONS_VERSION = 319351af7f3b546a5a56cdf6492f6ba1aec1cd2f
XBMC_PVR_ADDONS_SITE = $(call github,opdenkamp,xbmc-pvr-addons,$(XBMC_PVR_ADDONS_VERSION))
XBMC_PVR_ADDONS_LICENSE = GPLv3+
XBMC_PVR_ADDONS_LICENSE_FILES = COPYING

# There's no ./configure in the git tree, we need to generate it
XBMC_PVR_ADDONS_AUTORECONF = YES

XBMC_PVR_ADDONS_DEPENDENCIES = boost zlib
# This really is a runtime dependency, but we need XBMC to be installed
# first, since we'll install files in XBMC's directories _after_ XBMC has
# installed its own files
XBMC_PVR_ADDONS_DEPENDENCIES += xbmc

XBMC_PVR_ADDONS_CONF_OPT = \
	--enable-release \
	--enable-addons-with-dependencies

ifeq ($(BR2_PACKAGE_MYSQL),y)
XBMC_PVR_ADDONS_CONF_OPT += --enable-mysql
XBMC_PVR_ADDONS_DEPENDENCIES += mysql
else
XBMC_PVR_ADDONS_CONF_OPT += --disable-mysql
endif

$(eval $(autotools-package))
