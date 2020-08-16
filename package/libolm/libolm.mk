################################################################################
#
# libolm
#
################################################################################

LIBOLM_VERSION = 3.1.4
LIBOLM_SOURCE = olm-$(LIBOLM_VERSION).tar.gz
LIBOLM_SITE = https://gitlab.matrix.org/matrix-org/olm/-/archive/$(LIBOLM_VERSION)
LIBOLM_LICENSE = Apache-2.0
LIBOLM_LICENSE_FILES = LICENSE
LIBOLM_INSTALL_STAGING = YES

LIBOLM_CONF_OPTS = -DOLM_TESTS=OFF

$(eval $(cmake-package))
