################################################################################
#
# cdrkit
#
################################################################################

CDRKIT_VERSION = 1.1.11
CDRKIT_SOURCE = cdrkit_$(CDRKIT_VERSION).orig.tar.gz
CDRKIT_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/c/cdrkit
CDRKIT_DEPENDENCIES = libcap bzip2 zlib
CDRKIT_LICENSE = GPLv2
CDRKIT_LICENSE_FILES = COPYING

ifeq ($(BR2_ENDIAN),"BIG")
CDRKIT_CONF_OPTS += -DBITFIELDS_HTOL=1
else
CDRKIT_CONF_OPTS += -DBITFIELDS_HTOL=0
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
