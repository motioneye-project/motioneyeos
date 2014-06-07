################################################################################
#
# xbmc-addon-xvdr
#
################################################################################

# This cset is on master. When a Gotham branch is made, we should
# follow it, as incompatible changes in the plugins API can happen
# on the master branch.
XBMC_ADDON_XVDR_VERSION = 82b5093ad33847f97a978cb620c9a87d2dbcf7eb
XBMC_ADDON_XVDR_SITE = $(call github,pipelka,xbmc-addon-xvdr,$(XBMC_ADDON_XVDR_VERSION))
XBMC_ADDON_XVDR_LICENSE = GPLv2+
XBMC_ADDON_XVDR_LICENSE_FILES = COPYING

# There's no ./configure in the git tree, we need to generate it
# xbmc-addon-xvdr uses a weird autogen.sh script, which
# is even incorrect (it's missing the #! ) Sigh... :-(
# Fortunately, with our little patch, it autoreconfs nicely! :-)
XBMC_ADDON_XVDR_AUTORECONF = YES

# This really is a runtime dependency, but we need XBMC to be installed
# first, since we'll install files in XBMC's directories _after_ XBMC has
# installed his own files
XBMC_ADDON_XVDR_DEPENDENCIES = xbmc

$(eval $(autotools-package))
