################################################################################
#
# taskd
#
################################################################################

TASKD_VERSION = 1.1.0
TASKD_SITE = http://taskwarrior.org/download
TASKD_LICENSE = MIT
TASKD_LICENSE_FILES = COPYING
TASKD_DEPENDENCIES = gnutls util-linux host-pkgconf

$(eval $(cmake-package))
