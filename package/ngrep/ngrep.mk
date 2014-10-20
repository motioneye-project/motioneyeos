################################################################################
#
# ngrep
#
################################################################################

NGREP_VERSION = 1.45
NGREP_SOURCE = ngrep-$(NGREP_VERSION).tar.bz2
NGREP_SITE = http://downloads.sourceforge.net/project/ngrep/ngrep/$(NGREP_VERSION)
NGREP_LICENSE = BSD-4c-like
NGREP_LICENSE_FILES = LICENSE.txt
NGREP_INSTALL_STAGING = YES

NGREP_LIBS = -lpcap -lpcre
ifeq ($(BR2_PREFER_STATIC_LIB),y)
NGREP_LIBS += $(shell $(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs)
endif
NGREP_CONF_ENV += LIBS+="$(NGREP_LIBS)"

NGREP_CONF_OPTS =  \
	--with-pcap-includes=$(STAGING_DIR)/usr/include/pcap \
	--enable-pcre \
	--with-pcre=$(STAGING_DIR)/usr \
	--disable-dropprivs

NGREP_DEPENDENCIES = libpcap pcre

$(eval $(autotools-package))
