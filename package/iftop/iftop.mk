################################################################################
#
# iftop
#
################################################################################

IFTOP_VERSION = 1.0pre4
IFTOP_SITE = http://www.ex-parrot.com/pdw/iftop/download
IFTOP_DEPENDENCIES = ncurses libpcap
IFTOP_LICENSE = GPLv2+
IFTOP_LICENSE_FILES = COPYING

IFTOP_LIBS = -lpcap
ifeq ($(BR2_PREFER_STATIC_LIB),y)
IFTOP_LIBS += $(shell $(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs)
endif
IFTOP_CONF_ENV += LIBS+="$(IFTOP_LIBS)"

$(eval $(autotools-package))
