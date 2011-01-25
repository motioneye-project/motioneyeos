#############################################################
#
# libpcap
#
#############################################################

LIBPCAP_VERSION:=1.1.1
LIBPCAP_SITE:=http://www.tcpdump.org/release
LIBPCAP_SOURCE:=libpcap-$(LIBPCAP_VERSION).tar.gz
LIBPCAP_INSTALL_STAGING:=YES
# doesn't have an install-strip
LIBPCAP_INSTALL_TARGET_OPT= DESTDIR="$(TARGET_DIR)" \
	$(if $(BR2_PREFER_STATIC_LIB),install,install-shared)
LIBPCAP_INSTALL_STAGING_OPT= DESTDIR="$(STAGING_DIR)" install \
	$(if $(BR2_PREFER_STATIC_LIB),,install-shared)
LIBPCAP_DEPENDENCIES:=zlib
LIBPCAP_CONF_ENV:=ac_cv_linux_vers=2 \
		  ac_cv_header_linux_wireless_h=yes # configure misdetects this
LIBPCAP_CONF_OPT:=--disable-yydebug --with-pcap=linux

$(eval $(call AUTOTARGETS,package,libpcap))
