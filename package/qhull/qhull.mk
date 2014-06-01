################################################################################
#
# qhull
#
################################################################################

QHULL_VERSION = 60d55819729d7b49391dde0271e15a56c70992b9
QHULL_SITE = git://gitorious.org/qhull/qhull.git
QHULL_INSTALL_STAGING = YES
QHULL_LICENSE = BSD-Style
QHULL_LICENSE_FILES = COPYING.txt

$(eval $(cmake-package))
