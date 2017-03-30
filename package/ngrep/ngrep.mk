################################################################################
#
# ngrep
#
################################################################################

NGREP_VERSION = 1.45
NGREP_SOURCE = ngrep-$(NGREP_VERSION).tar.bz2
NGREP_SITE = http://downloads.sourceforge.net/project/ngrep/ngrep/$(NGREP_VERSION)
NGREP_LICENSE = BSD-4-Clause-like
NGREP_LICENSE_FILES = LICENSE.txt
NGREP_INSTALL_STAGING = YES

NGREP_LIBS = -lpcap -lpcre
ifeq ($(BR2_STATIC_LIBS),y)
NGREP_LIBS += `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`
endif
NGREP_CONF_ENV += LIBS+="$(NGREP_LIBS)"

NGREP_CONF_OPTS =  \
	--with-pcap-includes=$(STAGING_DIR)/usr/include/pcap \
	--enable-pcre \
	--with-pcre=$(STAGING_DIR)/usr \
	--disable-dropprivs \
	--disable-pcap-restart

NGREP_DEPENDENCIES = libpcap pcre

$(eval $(autotools-package))
