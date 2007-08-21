#############################################################
#
# ntp
#
#############################################################
NTP_VERSION:=4.2.4p2
NTP_SOURCE:=ntp-$(NTP_VERSION).tar.gz
NTP_SITE:=http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2
NTP_DIR:=$(BUILD_DIR)/ntp-$(NTP_VERSION)
NTP_CAT:=$(ZCAT)
NTP_BINARY:=ntpdate/ntpdate
NTP_TARGET_BINARY:=usr/bin/ntpdate

$(DL_DIR)/$(NTP_SOURCE):
	$(WGET) -P $(DL_DIR) $(NTP_SITE)/$(NTP_SOURCE)

ntp-source: $(DL_DIR)/$(NTP_SOURCE)

$(NTP_DIR)/.patched: $(DL_DIR)/$(NTP_SOURCE)
	$(NTP_CAT) $(DL_DIR)/$(NTP_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(NTP_DIR) package/ntp/ ntp\*.patch
	$(SED) "s,^#if.*__GLIBC__.*_BSD_SOURCE.*$$,#if 0," \
		$(NTP_DIR)/ntpd/refclock_pcf.c
	$(SED) '/[[:space:](]index[[:space:]]*(/s/[[:space:]]*index[[:space:]]*(/ strchr(/g' $(NTP_DIR)/libisc/*.c $(NTP_DIR)/arlib/sample.c
	$(SED) '/[[:space:](]rindex[[:space:]]*(/s/[[:space:]]*rindex[[:space:]]*(/ strrchr(/g' $(NTP_DIR)/ntpd/*.c
	#$(SED) 's/\(^#[[:space:]]*include[[:space:]]*<sys\/var.h>\)/\/\/ \1/' $(NTP_DIR)/util/tickadj.c
	$(CONFIG_UPDATE) $(NTP_DIR)
	$(CONFIG_UPDATE) $(NTP_DIR)/sntp
	touch $@

$(NTP_DIR)/.configured: $(NTP_DIR)/.patched
	(cd $(NTP_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
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
		$(DISABLE_IPV6) \
		--with-shared \
		--program-transform-name=s,,, \
		--without-crypto \
		--disable-tickadj \
	)
	touch $@

$(NTP_DIR)/$(NTP_BINARY): $(NTP_DIR)/.configured
	$(MAKE) -C $(NTP_DIR)

$(TARGET_DIR)/$(NTP_TARGET_BINARY): $(NTP_DIR)/$(NTP_BINARY)
	install -m 755 $(NTP_DIR)/ntpd/ntpd $(TARGET_DIR)/usr/sbin/ntpd
	install -m 755 $(NTP_DIR)/$(NTP_BINARY) $(TARGET_DIR)/$(NTP_TARGET_BINARY)
ifeq ($(BR2_PACKAGE_NTP_SNTP),y)
	install -m 755 $(NTP_DIR)/sntp/sntp $(TARGET_DIR)/usr/bin/sntp
endif
	install -m 755 package/ntp/ntp.sysvinit $(TARGET_DIR)/etc/init.d/S49ntp

ntp: uclibc $(TARGET_DIR)/$(NTP_TARGET_BINARY)

ntp-clean:
	rm -f $(TARGET_DIR)/usr/sbin/ntpd $(TARGET_DIR)/usr/bin/sntp \
		$(TARGET_DIR)/etc/init.d/S49ntp \
		$(TARGET_DIR)/$(NTP_TARGET_BINARY)
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
