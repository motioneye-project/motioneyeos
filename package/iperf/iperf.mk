#############################################################
#
# iperf
#
#############################################################

IPERF_VERSION:=2.0.2
IPERF_SOURCE:=iperf-$(IPERF_VERSION).tar.gz
IPERF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/iperf
IPERF_DIR:=$(BUILD_DIR)/iperf-$(IPERF_VERSION)
IPERF_CAT:=$(ZCAT)

$(DL_DIR)/$(IPERF_SOURCE):
	$(WGET) -P $(DL_DIR) $(IPERF_SITE)/$(IPERF_SOURCE)

$(IPERF_DIR)/.unpacked: $(DL_DIR)/$(IPERF_SOURCE)
	$(IPERF_CAT) $(DL_DIR)/$(IPERF_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IPERF_DIR) package/iperf/ iperf\*.patch
	$(CONFIG_UPDATE) $(IPERF_DIR)
	touch $(IPERF_DIR)/.unpacked

$(IPERF_DIR)/.configured: $(IPERF_DIR)/.unpacked
	(cd $(IPERF_DIR); rm -rf config.cache;  \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		ac_cv_func_malloc_0_nonnull=yes \
		./configure \
		--with-gnu-ld \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		$(DISABLE_IPV6) \
		--disable-dependency-tracking \
		--disable-web100 \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/sbin \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--includedir=$(STAGING_DIR)/usr/include \
	);
	touch $(IPERF_DIR)/.configured

$(IPERF_DIR)/src/iperf: $(IPERF_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(IPERF_DIR)
	-$(STRIP) --strip-unneeded $(IPERF_DIR)/src/iperf

$(TARGET_DIR)/usr/bin/iperf: $(IPERF_DIR)/src/iperf
	cp $(IPERF_DIR)/src/iperf $(TARGET_DIR)/usr/bin/iperf

iperf: $(TARGET_DIR)/usr/bin/iperf

iperf-source: $(DL_DIR)/$(IPERF_SOURCE)

iperf-clean:
	@if [ -d $(IPERF_KDIR)/Makefile ] ; then \
		$(MAKE) -C $(IPERF_DIR) clean ; \
	fi;

iperf-dirclean:
	rm -rf $(IPERF_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_IPERF)),y)
TARGETS+=iperf
endif
