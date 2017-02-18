################################################################################
#
# inotify-tools
#
################################################################################

INOTIFY_TOOLS_VERSION = 1df9af4d6cd0f4af4b1b19254bcf056aed4ae395
INOTIFY_TOOLS_SITE = $(call github,rvoicilas,inotify-tools,$(INOTIFY_TOOLS_VERSION))
INOTIFY_TOOLS_LICENSE = GPL
INOTIFY_TOOLS_LICENSE_FILES = COPYING
INOTIFY_TOOLS_INSTALL_STAGING = YES
INOTIFY_TOOLS_AUTORECONF = YES

$(eval $(autotools-package))
