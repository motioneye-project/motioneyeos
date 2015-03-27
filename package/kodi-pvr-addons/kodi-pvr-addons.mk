################################################################################
#
# kodi-pvr-addons
#
################################################################################

# This cset is on the branch 'helix'
# When Kodi is updated, this should be updated to the corresponding branch
KODI_PVR_ADDONS_VERSION = 4854fbe9dc0499ca8d1e10e8c18e329d3eb48814
KODI_PVR_ADDONS_SITE = $(call github,opdenkamp,xbmc-pvr-addons,$(KODI_PVR_ADDONS_VERSION))
KODI_PVR_ADDONS_LICENSE = GPLv3+
KODI_PVR_ADDONS_LICENSE_FILES = COPYING

# There's no ./configure in the git tree, we need to generate it
KODI_PVR_ADDONS_AUTORECONF = YES

KODI_PVR_ADDONS_DEPENDENCIES = zlib
# This really is a runtime dependency, but we need KODI to be installed
# first, since we'll install files in KODI's directories _after_ KODI has
# installed its own files
KODI_PVR_ADDONS_DEPENDENCIES += kodi

KODI_PVR_ADDONS_CONF_OPTS = \
	--enable-release \
	--enable-addons-with-dependencies

$(eval $(autotools-package))
