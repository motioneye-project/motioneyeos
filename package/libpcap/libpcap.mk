#############################################################
#
# libpcap
#
#############################################################

LIBPCAP_VERSION:=1.0.0
LIBPCAP_SITE:=http://www.tcpdump.org/release
LIBPCAP_SOURCE:=libpcap-$(LIBPCAP_VERSION).tar.gz
LIBPCAP_INSTALL_STAGING:=YES
# doesn't have an install-strip
LIBPCAP_INSTALL_TARGET_OPT= DESTDIR="$(TARGET_DIR)" \
	$(if $(BR2_PREFER_STATIC_LIB),install,install-shared)
LIBPCAP_INSTALL_STAGING_OPT= DESTDIR="$(STAGING_DIR)" install \
	$(if $(BR2_PREFER_STATIC_LIB),,install-shared)
LIBPCAP_DEPENDENCIES:=zlib
LIBPCAP_CONF_ENV:=ac_cv_linux_vers=$(firstword $(subst .,$(space),$(firstword $(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS))))) \
		  ac_cv_header_linux_wireless_h=yes # configure misdetects this
LIBPCAP_CONF_OPT:=--disable-yydebug --with-pcap=linux

$(eval $(call AUTOTARGETS,package,libpcap))

$(LIBPCAP_HOOK_POST_INSTALL): $(LIBPCAP_TARGET_INSTALL_TARGET)
ifeq ($(BR2_PREFER_STATIC_LIB),)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(wildcard $(TARGET_DIR)/usr/lib/libpcap.so*)
endif
	touch $@

