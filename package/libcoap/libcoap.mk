################################################################################
#
# libcoap
#
################################################################################

LIBCOAP_VERSION = c909bf802034b7762a2182848304b2530e58444f
LIBCOAP_SITE = $(call github,obgm,libcoap,$(LIBCOAP_VERSION))
LIBCOAP_INSTALL_STAGING = YES
LIBCOAP_LICENSE = GPL-2.0+ or BSD-2-Clause
LIBCOAP_LICENSE_FILES = COPYING LICENSE.GPL LICENSE.BSD
LIBCOAP_CONF_OPTS = --disable-examples
LIBCOAP_AUTORECONF = YES

$(eval $(autotools-package))
