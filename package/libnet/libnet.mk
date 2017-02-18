################################################################################
#
# libnet
#
################################################################################

LIBNET_VERSION = 1.1.6
LIBNET_SITE = http://sourceforge.net/projects/libnet-dev/files
LIBNET_INSTALL_STAGING = YES
# PF_PACKET is always available on Linux
LIBNET_CONF_OPTS = libnet_cv_have_packet_socket=yes
LIBNET_LICENSE = BSD-2c, BSD-3c
LIBNET_LICENSE_FILES = doc/COPYING

$(eval $(autotools-package))
