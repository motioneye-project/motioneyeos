################################################################################
#
# inotify-tools
#
################################################################################

INOTIFY_TOOLS_VERSION = 06007d350faa8731c67e186923ab417486104719
INOTIFY_TOOLS_SITE = $(call github,rvoicilas,inotify-tools,$(INOTIFY_TOOLS_VERSION))
INOTIFY_TOOLS_LICENSE = GPL
INOTIFY_TOOLS_LICENSE_FILES = COPYING
INOTIFY_TOOLS_INSTALL_STAGING = YES
INOTIFY_TOOLS_AUTORECONF = YES

$(eval $(autotools-package))
