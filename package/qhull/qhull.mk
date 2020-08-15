################################################################################
#
# qhull
#
################################################################################

QHULL_VERSION = 7.3.2
QHULL_SITE = http://www.qhull.org/download
QHULL_SOURCE = qhull-2019-src-$(QHULL_VERSION).tgz
QHULL_INSTALL_STAGING = YES
QHULL_LICENSE = BSD-Style
QHULL_LICENSE_FILES = COPYING.txt

$(eval $(cmake-package))
