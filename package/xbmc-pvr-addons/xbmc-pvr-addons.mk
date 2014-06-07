################################################################################
#
# xbmc-pvr-addons
#
################################################################################

# This cset in on master. When a Gotham branch is made, we should
# follow it, as incompatible changes in the plugins API can happen
# on the master branch.
XBMC_PVR_ADDONS_VERSION = f38b2ebdc6f96244d5e4bc584315f4a2c24bc787
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
