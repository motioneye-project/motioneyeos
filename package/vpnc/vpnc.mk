#############################################################
#
# vpnc
#
#############################################################

VPNC_VERSION=0.4.0
VPNC_SOURCE=vpnc-$(VPNC_VERSION).tar.gz
VPNC_SITE=http://www.unix-ag.uni-kl.de/~massar/vpnc
VPNC_DIR=$(BUILD_DIR)/vpnc-$(VPNC_VERSION)
VPNC_CAT:=$(ZCAT)
VPNC_BINARY:=$(VPNC_DIR)/vpnc
VPNC_DEST_DIR:=$(TARGET_DIR)/usr/local/sbin
VPNC_TARGET_BINARY:=$(VPNC_DEST_DIR)/vpnc
VPNC_TARGET_SCRIPT:=$(TARGET_DIR)/etc/vpnc/default.conf

$(DL_DIR)/$(VPNC_SOURCE):
	$(WGET) -P $(DL_DIR) $(VPNC_SITE)/$(VPNC_SOURCE)

$(VPNC_DIR)/.unpacked: $(DL_DIR)/$(VPNC_SOURCE)
	$(VPNC_CAT) $(DL_DIR)/$(VPNC_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(VPNC_DIR) package/vpnc \*.patch
	touch $(VPNC_DIR)/.unpacked

$(VPNC_DIR)/.configured: $(VPNC_DIR)/.unpacked
	touch $(VPNC_DIR)/.configured

$(VPNC_BINARY): $(VPNC_DIR)/.configured
	rm -f $@
	$(MAKE) $(TARGET_CONFIGURE_OPTS) INCLUDE=$(STAGING_DIR)/usr/include \
		CC=$(TARGET_CC) -C $(VPNC_DIR)

$(VPNC_TARGET_BINARY): $(VPNC_BINARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS)		\
		DESTDIR=$(TARGET_DIR)			\
		BINDIR=/usr/local/bin			\
		SBINDIR=/usr/local/sbin			\
		ETCDIR=/etc/vpnc			\
		MANDIR=/usr/local/share/man		\
		VERSION=$(VPNC_VERSION)			\
		INCLUDE=$(STAGING_DIR)/usr/include	\
		LDFLAGS="-g -lgcrypt -lgpg-error"	\
		-C $(VPNC_DIR) install
	$(STRIP) --strip-unneeded $(VPNC_TARGET_BINARY)

#		CFLAGS+="-W -Wall -O3 -Wmissing-declarations -Wwrite-strings -g -DVERSION=\"$(VPNC_VERSION)\" -c"	\



vpnc: uclibc $(VPNC_TARGET_BINARY)

vpnc-source: $(DL_DIR)/$(VPNC_SOURCE)

vpnc-clean:
	@if [ -d $(VPNC_DIR)/Makefile ] ; then \
		$(MAKE) -C $(VPNC_DIR) clean ; \
	fi;
	rm -f $(STAGING_DIR)/usr/bin/vpnc

vpnc-dirclean:
	rm -rf $(VPNC_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_VPNC)),y)
TARGETS+=vpnc
endif
