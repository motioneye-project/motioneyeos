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
NGREP_CONF_ENV = LDFLAGS="-lpcre"
NGREP_CONF_OPT =  \
	--with-pcap-includes=$(STAGING_DIR)/usr/include \
	--enable-pcre \
	--with-pcre=$(STAGING_DIR)/usr \
	--disable-dropprivs

NGREP_DEPENDENCIES = libpcap pcre

$(eval $(autotools-package))
