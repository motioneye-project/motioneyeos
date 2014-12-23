################################################################################
#
# kodi-pvr-addons
#
################################################################################

# This cset is on the branch 'gotham'
# When Kodi is updated, then this should be updated to the corresponding branch
KODI_PVR_ADDONS_VERSION = be12a8da2072e9c3ddad54892df2f85b759d4e9a
KODI_PVR_ADDONS_SITE = $(call github,opdenkamp,xbmc-pvr-addons,$(KODI_PVR_ADDONS_VERSION))
KODI_PVR_ADDONS_LICENSE = GPLv3+
KODI_PVR_ADDONS_LICENSE_FILES = COPYING

# There's no ./configure in the git tree, we need to generate it
KODI_PVR_ADDONS_AUTORECONF = YES

KODI_PVR_ADDONS_DEPENDENCIES = boost zlib
# This really is a runtime dependency, but we need KODI to be installed
# first, since we'll install files in KODI's directories _after_ KODI has
# installed its own files
KODI_PVR_ADDONS_DEPENDENCIES += kodi

KODI_PVR_ADDONS_CONF_OPTS = \
	--enable-release \
	--enable-addons-with-dependencies

ifeq ($(BR2_PACKAGE_MYSQL),y)
KODI_PVR_ADDONS_CONF_OPTS += --enable-mysql
KODI_PVR_ADDONS_DEPENDENCIES += mysql
else
KODI_PVR_ADDONS_CONF_OPTS += --disable-mysql
endif

$(eval $(autotools-package))
