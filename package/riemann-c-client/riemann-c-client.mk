################################################################################
#
# riemann-c-client
#
################################################################################

RIEMANN_C_CLIENT_VERSION = 1.10.4
RIEMANN_C_CLIENT_SITE = \
	$(call github,algernon,riemann-c-client,riemann-c-client-$(RIEMANN_C_CLIENT_VERSION))
RIEMANN_C_CLIENT_LICENSE = LGPL-3.0+
RIEMANN_C_CLIENT_LICENSE_FILES = LICENSE
RIEMANN_C_CLIENT_INSTALL_STAGING = YES
RIEMANN_C_CLIENT_MAKE = $(MAKE1)
# From git
RIEMANN_C_CLIENT_AUTORECONF = YES
RIEMANN_C_CLIENT_DEPENDENCIES = \
	host-pkgconf protobuf-c \
	$(if $(BR2_PACKAGE_GNUTLS),gnutls) \
	$(if $(BR2_PACKAGE_JSON_C),json-c)

$(eval $(autotools-package))
