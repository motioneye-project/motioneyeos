################################################################################
#
# gnuchess
#
################################################################################

GNUCHESS_VERSION = 5.07
GNUCHESS_SOURCE = gnuchess-$(GNUCHESS_VERSION).tar.gz
GNUCHESS_SITE = $(BR2_GNU_MIRROR)/chess
GNUCHESS_LICENSE = GPLv2+
GNUCHESS_LICENSE_FILES = COPYING

GNUCHESS_DEPENDENCIES = host-flex flex
GNUCHESS_DEPENDENCIES += $(if $(BR2_PACKAGE_READLINE),readline)

$(eval $(autotools-package))

