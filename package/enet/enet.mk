################################################################################
#
# enet
#
################################################################################

ENET_VERSION = 1.3.14
ENET_SITE = http://enet.bespin.org/download
ENET_LICENSE = MIT
ENET_LICENSE_FILES = LICENSE

ENET_INSTALL_STAGING = YES

$(eval $(autotools-package))
