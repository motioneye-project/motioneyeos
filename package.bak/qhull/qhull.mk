################################################################################
#
# qhull
#
################################################################################

QHULL_VERSION = 7.2.0
QHULL_SITE = http://www.qhull.org/download
QHULL_SOURCE = qhull-2015-src-$(QHULL_VERSION).tgz
QHULL_INSTALL_STAGING = YES
QHULL_LICENSE = BSD-Style
QHULL_LICENSE_FILES = COPYING.txt

$(eval $(cmake-package))
