################################################################################
#
# czmq
#
################################################################################

CZMQ_VERSION = 4.2.0
CZMQ_SITE = https://github.com/zeromq/czmq/releases/download/v$(CZMQ_VERSION)

CZMQ_INSTALL_STAGING = YES
CZMQ_DEPENDENCIES = zeromq host-pkgconf
CZMQ_LICENSE = MPL-2.0
CZMQ_LICENSE_FILES = LICENSE

CZMQ_CONF_OPTS = --disable-Werror --without-docs

$(eval $(autotools-package))
