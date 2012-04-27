#############################################################
#
# ngrep
#
#############################################################

NGREP_VERSION = 1.45
NGREP_SOURCE = ngrep-$(NGREP_VERSION).tar.bz2
NGREP_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ngrep/ngrep/$(NGREP_VERSION)
NGREP_INSTALL_STAGING = YES
NGREP_CONF_ENV = LDFLAGS="-lpcre"
NGREP_CONF_OPT =  \
	--with-pcap-includes=$(STAGING_DIR)/usr/include \
	--enable-pcre \
	--with-pcre=$(STAGING_DIR)/usr \
	--disable-dropprivs

NGREP_DEPENDENCIES = libpcap pcre

$(eval $(call AUTOTARGETS))
