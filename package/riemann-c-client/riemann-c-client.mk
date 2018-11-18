################################################################################
#
# riemann-c-client
#
################################################################################

RIEMANN_C_CLIENT_VERSION = 1.9.1
RIEMANN_C_CLIENT_SOURCE = riemann-c-client-$(RIEMANN_C_CLIENT_VERSION).tar.xz
RIEMANN_C_CLIENT_SITE = https://github.com/algernon/riemann-c-client/releases/download/riemann-c-client-$(RIEMANN_C_CLIENT_VERSION)
RIEMANN_C_CLIENT_LICENSE = LGPL-3.0+
RIEMANN_C_CLIENT_LICENSE_FILES = LICENSE
RIEMANN_C_CLIENT_INSTALL_STAGING = YES
RIEMANN_C_CLIENT_MAKE = $(MAKE1)
RIEMANN_C_CLIENT_DEPENDENCIES = \
	host-pkgconf protobuf-c \
	$(if $(BR2_PACKAGE_GNUTLS),gnutls) \
	$(if $(BR2_PACKAGE_JSON_C),json-c)

$(eval $(autotools-package))
