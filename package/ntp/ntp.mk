#############################################################
#
# ntp
#
#############################################################
NTP_VERSION:=4.2.0
NTP_SOURCE:=ntp-$(NTP_VERSION).tar.gz
NTP_SITE:=http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2
NTP_DIR:=$(BUILD_DIR)/ntp-$(NTP_VERSION)
NTP_CAT:=$(ZCAT)
NTP_BINARY:=ntpdate/ntpdate
NTP_TARGET_BINARY:=usr/bin/ntpdate

$(DL_DIR)/$(NTP_SOURCE):
	$(WGET) -P $(DL_DIR) $(NTP_SITE)/$(NTP_SOURCE)

ntp-source: $(DL_DIR)/$(NTP_SOURCE)

$(NTP_DIR)/.unpacked: $(DL_DIR)/$(NTP_SOURCE)
	$(NTP_CAT) $(DL_DIR)/$(NTP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(NTP_DIR) package/ntp/ ntp\*.patch
	$(SED) "s,^#if.*__GLIBC__.*_BSD_SOURCE.*$$,#if 0," \
		$(NTP_DIR)/ntpd/refclock_pcf.c;
	touch $(NTP_DIR)/.unpacked

$(NTP_DIR)/.configured: $(NTP_DIR)/.unpacked
	(cd $(NTP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		ac_cv_lib_md5_MD5Init=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		--with-shared \
		--program-transform-name=s,,, \
		--without-crypto \
	);
	touch $(NTP_DIR)/.configured

$(NTP_DIR)/$(NTP_BINARY): $(NTP_DIR)/.configured
	$(MAKE) -C $(NTP_DIR)

$(TARGET_DIR)/$(NTP_TARGET_BINARY): $(NTP_DIR)/$(NTP_BINARY)
	install -m 755 $(NTP_DIR)/ntpd/ntpd $(TARGET_DIR)/usr/sbin/ntpd
	install -m 755 $(NTP_DIR)/$(NTP_BINARY) $(TARGET_DIR)/$(NTP_TARGET_BINARY)

ntp: uclibc $(TARGET_DIR)/$(NTP_TARGET_BINARY)

ntp-clean:
	rm -f $(TARGET_DIR)/usr/sbin/ntpd
	rm -f $(TARGET_DIR)/$(NTP_TARGET_BINARY)
	-$(MAKE) -C $(NTP_DIR) clean

ntp-dirclean:
	rm -rf $(NTP_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NTP)),y)
TARGETS+=ntp
endif
