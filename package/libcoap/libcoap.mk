################################################################################
#
# libcoap
#
################################################################################

LIBCOAP_VERSION = 4.2.0
LIBCOAP_SITE = $(call github,obgm,libcoap,v$(LIBCOAP_VERSION))
LIBCOAP_INSTALL_STAGING = YES
LIBCOAP_LICENSE = BSD-2-Clause
LIBCOAP_LICENSE_FILES = COPYING LICENSE
LIBCOAP_DEPENDENCIES = host-pkgconf
LIBCOAP_CONF_OPTS = --disable-examples
LIBCOAP_AUTORECONF = YES

$(eval $(autotools-package))
