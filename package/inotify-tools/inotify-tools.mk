################################################################################
#
# inotify-tools
#
################################################################################

INOTIFY_TOOLS_VERSION = 3.14
INOTIFY_TOOLS_SITE = http://github.com/downloads/rvoicilas/inotify-tools
INOTIFY_TOOLS_LICENSE = GPL
INOTIFY_TOOLS_LICENSE_FILES = COPYING
INOTIFY_TOOLS_INSTALL_STAGING = YES

$(eval $(autotools-package))
