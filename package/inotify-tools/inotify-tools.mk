#############################################################
#
# inotify-utils
#
#############################################################
INOTIFY_TOOLS_VERSION = 3.14
INOTIFY_TOOLS_SITE = http://github.com/downloads/rvoicilas/inotify-tools/
INOTIFY_TOOLS_LICENSE = GPLv2+
INOTIFY_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
