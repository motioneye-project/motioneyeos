#############################################################
#
# tftpd
#
#############################################################
TFTP_HPA_VER:=0.40
TFTP_HPA_SOURCE:=tftp-hpa-$(TFTP_HPA_VER).tar.bz2
TFTP_HPA_SITE:=http://www.kernel.org/pub/software/network/tftp/
TFTP_HPA_DIR:=$(BUILD_DIR)/tftp-hpa-$(TFTP_HPA_VER)
TFTP_HPA_CAT:=bzcat
TFTP_HPA_BINARY:=tftpd/tftpd
TFTP_HPA_TARGET_BINARY:=usr/sbin/in.tftpd

$(DL_DIR)/$(TFTP_HPA_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TFTP_HPA_SITE)/$(TFTP_HPA_SOURCE)

tftpd-source: $(DL_DIR)/$(TFTP_HPA_SOURCE)

$(TFTP_HPA_DIR)/.unpacked: $(DL_DIR)/$(TFTP_HPA_SOURCE)
	$(TFTP_HPA_CAT) $(DL_DIR)/$(TFTP_HPA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TFTP_HPA_DIR) package/tftpd/ tftpd*.patch
	touch $(TFTP_HPA_DIR)/.unpacked

$(TFTP_HPA_DIR)/.configured: $(TFTP_HPA_DIR)/.unpacked
	(cd $(TFTP_HPA_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_LARGEFILE) \
		--without-tcpwrappers \
	);
	touch  $(TFTP_HPA_DIR)/.configured

$(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY): $(TFTP_HPA_DIR)/.configured
	$(MAKE) -C $(TFTP_HPA_DIR)

# This stuff is needed to work around GNU make deficiencies
$(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY): $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY)
	@if [ -L $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY) ] ; then \
		rm -f $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); fi;
	@if [ ! -f $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) -o $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY) \
	-ot $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) ] ; then \
	    set -x; \
	    rm -f $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); \
	    cp -a $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); fi ;
	$(INSTALL) -D -m 0755 package/tftpd/init-tftpd $(TARGET_DIR)/etc/init.d/S80tftpd-hpa
	$(INSTALL) -D -m 0644 package/tftpd/default-tftpd $(TARGET_DIR)/etc/default/tftpd-hpa

tftpd: uclibc $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY)

tftpd-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(TFTP_HPA_DIR) uninstall
	-$(MAKE) -C $(TFTP_HPA_DIR) clean

tftpd-dirclean:
	rm -rf $(TFTP_HPA_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_TFTPD)),y)
TARGETS+=tftpd
endif
