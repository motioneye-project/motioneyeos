#############################################################
#
# lsuio
#
#############################################################

LSUIO_VERSION = 0.2.0
LSUIO_SOURCE = lsuio-$(LSUIO_VERSION).tar.gz
LSUIO_SITE = http://www.osadl.org/projects/downloads/UIO/user

$(eval $(autotools-package))
