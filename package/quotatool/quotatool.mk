################################################################################
#
# quotatool
#
################################################################################

QUOTATOOL_VERSION = 1.6.2
QUOTATOOL_SITE = http://quotatool.ekenberg.se
QUOTATOOL_LICENSE = GPL-2.0
QUOTATOOL_LICENSE_FILES = COPYING

# men="" allows to disable installing the man pages, which fails
# because the package Makefile doesn't create the appropriate
# directory.
QUOTATOOL_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) install men=""

$(eval $(autotools-package))
