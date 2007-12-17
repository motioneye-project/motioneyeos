#############################################################
#
# tftpd
#
#############################################################
TFTP_HPA_VERSION:=0.40
TFTP_HPA_SOURCE:=tftp-hpa-$(TFTP_HPA_VERSION).tar.bz2
TFTP_HPA_SITE:=$(BR2_KERNEL_MIRROR)/software/network/tftp/
TFTP_HPA_DIR:=$(BUILD_DIR)/tftp-hpa-$(TFTP_HPA_VERSION)
TFTP_HPA_CAT:=$(BZCAT)
TFTP_HPA_BINARY:=tftpd/tftpd
TFTP_HPA_TARGET_BINARY:=usr/sbin/in.tftpd

$(DL_DIR)/$(TFTP_HPA_SOURCE):
	 $(WGET) -P $(DL_DIR) $(TFTP_HPA_SITE)/$(TFTP_HPA_SOURCE)

tftpd-source: $(DL_DIR)/$(TFTP_HPA_SOURCE)

$(TFTP_HPA_DIR)/.unpacked: $(DL_DIR)/$(TFTP_HPA_SOURCE)
	$(TFTP_HPA_CAT) $(DL_DIR)/$(TFTP_HPA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(TFTP_HPA_DIR) package/tftpd/ tftpd\*.patch
	touch $(TFTP_HPA_DIR)/.unpacked

$(TFTP_HPA_DIR)/.configured: $(TFTP_HPA_DIR)/.unpacked
	(cd $(TFTP_HPA_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
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
		$(DISABLE_LARGEFILE) \
		--without-tcpwrappers \
	)
	touch $(TFTP_HPA_DIR)/.configured

$(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY): $(TFTP_HPA_DIR)/.configured
	$(MAKE) -C $(TFTP_HPA_DIR)

# This stuff is needed to work around GNU make deficiencies
$(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY): $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY)
	@if [ -L $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY) ]; then \
		rm -f $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); fi
	@if [ ! -f $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) -o $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY) \
	-ot $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) ]; then \
	    set -x; \
	    rm -f $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); \
	    cp -a $(TFTP_HPA_DIR)/$(TFTP_HPA_BINARY) $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY); fi
	@if [ ! -f $(TARGET_DIR)/etc/init.d/S80tftpd-hpa ]; then \
		$(INSTALL) -m 0755 package/tftpd/S80tftpd-hpa $(TARGET_DIR)/etc/init.d; \
	fi

tftpd: uclibc $(TARGET_DIR)/$(TFTP_HPA_TARGET_BINARY)

tftpd-clean:
	rm -f $(TARGET_DIR)/etc/init.d/S80tftpd-hpa
	rm -f $(TARGET_DIR)/usr/sbin/in.tftpd
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
