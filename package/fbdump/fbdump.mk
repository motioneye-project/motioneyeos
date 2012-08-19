#############################################################
#
# fbdump
#
#############################################################
FBDUMP_VERSION:=0.4.2
FBDUMP_SOURCE:=fbdump-$(FBDUMP_VERSION).tar.gz
FBDUMP_SITE:=http://www.rcdrummond.net/fbdump
FBDUMP_LICENSE = GPLv2
FBDUMP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
