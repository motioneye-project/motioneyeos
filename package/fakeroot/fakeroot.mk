#############################################################
#
# fakeroot
#
#############################################################
FAKEROOT_VERSION:=1.5.8
FAKEROOT_SOURCE:=fakeroot_$(FAKEROOT_VERSION).tar.gz
FAKEROOT_SITE:=http://ftp.debian.org/debian/pool/main/f/fakeroot
FAKEROOT_CAT:=zcat
FAKEROOT_DIR1:=$(TOOL_BUILD_DIR)/fakeroot-$(FAKEROOT_VERSION)
FAKEROOT_DIR2:=$(BUILD_DIR)/fakeroot-$(FAKEROOT_VERSION)


$(DL_DIR)/$(FAKEROOT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(FAKEROOT_SITE)/$(FAKEROOT_SOURCE)

fakeroot-source: $(DL_DIR)/$(FAKEROOT_SOURCE)


#############################################################
#
# build fakeroot for use on the host system
#
#############################################################
$(FAKEROOT_DIR1)/.unpacked: $(DL_DIR)/$(FAKEROOT_SOURCE)
	$(FAKEROOT_CAT) $(DL_DIR)/$(FAKEROOT_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	$(SED) "s,getopt --version,getopt --version 2>/dev/null," \
		$(FAKEROOT_DIR1)/scripts/fakeroot.in
	toolchain/patch-kernel.sh $(FAKEROOT_DIR1) package/fakeroot/ \*.patch
	touch $(FAKEROOT_DIR1)/.unpacked

$(FAKEROOT_DIR1)/.configured: $(FAKEROOT_DIR1)/.unpacked
	(cd $(FAKEROOT_DIR1); rm -rf config.cache; \
		CC="$(HOSTCC)" \
		./configure \
		--prefix=/usr \
		$(DISABLE_NLS) \
	);
	touch $(FAKEROOT_DIR1)/.configured

$(FAKEROOT_DIR1)/faked: $(FAKEROOT_DIR1)/.configured
	$(MAKE) -C $(FAKEROOT_DIR1)

$(STAGING_DIR)/usr/bin/fakeroot: $(FAKEROOT_DIR1)/faked
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(FAKEROOT_DIR1) install
	$(SED) 's,^PREFIX=.*,PREFIX=$(STAGING_DIR)/usr,g' $(STAGING_DIR)/usr/bin/fakeroot
	$(SED) 's,^BINDIR=.*,BINDIR=$(STAGING_DIR)/usr/bin,g' $(STAGING_DIR)/usr/bin/fakeroot
	$(SED) 's,^PATHS=.*,PATHS=$(FAKEROOT_DIR1)/.libs:/lib:/usr/lib,g' $(STAGING_DIR)/usr/bin/fakeroot

host-fakeroot: uclibc $(STAGING_DIR)/usr/bin/fakeroot

host-fakeroot-clean:
	$(MAKE) -C $(FAKEROOT_DIR1) clean

host-fakeroot-dirclean:
	rm -rf $(FAKEROOT_DIR1)


#############################################################
#
# build fakeroot for use on the target system
#
#############################################################
$(FAKEROOT_DIR2)/.unpacked: $(DL_DIR)/$(FAKEROOT_SOURCE)
	$(FAKEROOT_CAT) $(DL_DIR)/$(FAKEROOT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# If using busybox getopt, make it be quiet.
	$(SED) "s,getopt --version,getopt --version 2>/dev/null," \
		$(FAKEROOT_DIR2)/scripts/fakeroot.in
	touch $(FAKEROOT_DIR2)/.unpacked

$(FAKEROOT_DIR2)/.configured: $(FAKEROOT_DIR2)/.unpacked
	(cd $(FAKEROOT_DIR2); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib/libfakeroot \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
	);
	touch $(FAKEROOT_DIR2)/.configured

$(FAKEROOT_DIR2)/faked: $(FAKEROOT_DIR2)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(FAKEROOT_DIR2)

$(TARGET_DIR)/usr/bin/fakeroot: $(FAKEROOT_DIR2)/faked
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(FAKEROOT_DIR2) install
	-mv $(TARGET_DIR)/usr/bin/$(ARCH)-linux-faked $(TARGET_DIR)/usr/bin/faked
	-mv $(TARGET_DIR)/usr/bin/$(ARCH)-linux-fakeroot $(TARGET_DIR)/usr/bin/fakeroot
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

fakeroot: uclibc $(TARGET_DIR)/usr/bin/fakeroot

fakeroot-clean:
	$(MAKE) -C $(FAKEROOT_DIR2) clean

fakeroot-dirclean:
	rm -rf $(FAKEROOT_DIR2)


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_FAKEROOT)),y)
TARGETS+=fakeroot
endif
