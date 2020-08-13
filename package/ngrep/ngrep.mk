################################################################################
#
# ngrep
#
################################################################################

NGREP_VERSION = 1.47
NGREP_SITE = $(call github,jpr5,ngrep,$(subst .,_,V$(NGREP_VERSION)))
NGREP_LICENSE = BSD-4-Clause-like, BSD-3-Clause (tcpkill)
NGREP_LICENSE_FILES = LICENSE
NGREP_INSTALL_STAGING = YES
# We're patching configure.in
NGREP_AUTORECONF = YES

ifeq ($(BR2_STATIC_LIBS),y)
NGREP_CONF_ENV += LIBS=`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`
endif

NGREP_CONF_OPTS = \
	--with-pcap-includes=$(STAGING_DIR)/usr/include/pcap \
	--enable-pcre \
	--disable-dropprivs \
	--disable-pcap-restart

NGREP_DEPENDENCIES = libpcap pcre

ifeq ($(BR2_PACKAGE_LIBNET),y)
NGREP_DEPENDENCIES += libnet
NGREP_CONF_OPTS += --enable-tcpkill
else
NGREP_CONF_OPTS += --disable-tcpkill
endif

$(eval $(autotools-package))
