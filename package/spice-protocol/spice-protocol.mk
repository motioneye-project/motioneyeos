################################################################################
#
# spice-protocol
#
################################################################################

SPICE_PROTOCOL_VERSION = 0.14.0
SPICE_PROTOCOL_SOURCE = spice-protocol-$(SPICE_PROTOCOL_VERSION).tar.bz2
SPICE_PROTOCOL_SITE = http://www.spice-space.org/download/releases
SPICE_PROTOCOL_LICENSE = BSD-3-Clause
SPICE_PROTOCOL_LICENSE_FILES = COPYING
SPICE_PROTOCOL_INSTALL_STAGING = YES

$(eval $(autotools-package))
