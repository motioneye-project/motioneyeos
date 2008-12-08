#############################################################
#
# udev
#
#############################################################
UDEV_VERSION:=114
UDEV_VOLUME_ID_CURRENT:=0
UDEV_VOLUME_ID_AGE:=79
UDEV_VOLUME_ID_REVISION:=0
UDEV_VOLUME_ID_VERSION:=$(UDEV_VOLUME_ID_CURRENT).$(UDEV_VOLUME_ID_AGE).$(UDEV_VOLUME_ID_REVISION)
UDEV_SOURCE:=udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE:=$(BR2_KERNEL_MIRROR)/linux/utils/kernel/hotplug/
UDEV_CAT:=$(BZCAT)
UDEV_DIR:=$(BUILD_DIR)/udev-$(UDEV_VERSION)
UDEV_TARGET_BINARY:=sbin/udevd
UDEV_BINARY:=udevd

# 094 had _GNU_SOURCE set
BR2_UDEV_CFLAGS:= -D_GNU_SOURCE $(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),)
BR2_UDEV_CFLAGS+=-U_FILE_OFFSET_BITS
endif

# UDEV_ROOT is /dev so we can replace devfs, not /udev for experiments
UDEV_ROOT:=/dev

$(DL_DIR)/$(UDEV_SOURCE):
	 $(WGET) -P $(DL_DIR) $(UDEV_SITE)/$(UDEV_SOURCE)

$(UDEV_DIR)/.unpacked: $(DL_DIR)/$(UDEV_SOURCE)
	$(UDEV_CAT) $(DL_DIR)/$(UDEV_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UDEV_DIR) package/udev \*.patch
	touch $@

$(UDEV_DIR)/$(UDEV_BINARY): $(UDEV_DIR)/.unpacked
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) CC=$(TARGET_CC) LD=$(TARGET_CC)\
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR)
	touch -c $@

$(TARGET_DIR)/$(UDEV_TARGET_BINARY): $(UDEV_DIR)/$(UDEV_BINARY)
	mkdir -p $(TARGET_DIR)/sys
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		LDFLAGS="-warn-common" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR) install
	$(INSTALL) -m 0755 package/udev/S10udev $(TARGET_DIR)/etc/init.d
	$(INSTALL) -m 0644 $(UDEV_DIR)/etc/udev/frugalware/* $(TARGET_DIR)/etc/udev/rules.d
	( grep udev_root $(TARGET_DIR)/etc/udev/udev.conf > /dev/null 2>&1 || echo 'udev_root=/dev' >> $(TARGET_DIR)/etc/udev/udev.conf )
	install -m 0755 -D $(UDEV_DIR)/udevstart $(TARGET_DIR)/sbin/udevstart
	rm -rf $(TARGET_DIR)/usr/share/man
ifneq ($(BR2_PACKAGE_UDEV_UTILS),y)
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor
	rm -f $(TARGET_DIR)/usr/bin/udevinfo
	rm -f $(TARGET_DIR)/usr/bin/udevtest
endif

#####################################################################
.PHONY: udev-source udev udev-clean udev-dirclean

udev: uclibc $(TARGET_DIR)/$(UDEV_TARGET_BINARY)

udev-source: $(DL_DIR)/$(UDEV_SOURCE)

udev-clean: $(UDEV_CLEAN_DEPS)
	rm -f $(TARGET_DIR)/etc/init.d/S10udev $(TARGET_DIR)/sbin/udev*
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor $(TARGET_DIR)/usr/bin/udev*
	rm -fr $(TARGET_DIR)/sys
	-$(MAKE) -C $(UDEV_DIR) clean


udev-dirclean: $(UDEV_DIRCLEAN_DEPS)
	rm -rf $(UDEV_DIR)

#####################################################################
ifeq ($(BR2_PACKAGE_UDEV_VOLUME_ID),y)
.PHONY: udev-volume_id udev-volume_id-clean udev-volume_id-dirclean

$(STAGING_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION):
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/volume_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0644 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.h $(STAGING_DIR)/usr/include/libvolume_id.h
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/usr/lib/libvolume_id.so.0
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/usr/lib/libvolume_id.so

$(STAGING_DIR)/usr/lib/libvolume_id.la: $(STAGING_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	$(INSTALL) -m 0755 -D package/udev/libvolume_id.la.tmpl $(STAGING_DIR)/usr/lib/libvolume_id.la
	$(SED) 's/REPLACE_CURRENT/$(UDEV_VOLUME_ID_CURRENT)/g' $(STAGING_DIR)/usr/lib/libvolume_id.la
	$(SED) 's/REPLACE_AGE/$(UDEV_VOLUME_ID_AGE)/g' $(STAGING_DIR)/usr/lib/libvolume_id.la
	$(SED) 's/REPLACE_REVISION/$(UDEV_VOLUME_ID_REVISION)/g' $(STAGING_DIR)/usr/lib/libvolume_id.la
	$(SED) 's,REPLACE_LIB_DIR,$(STAGING_DIR)/usr/lib,g' $(STAGING_DIR)/usr/lib/libvolume_id.la

$(TARGET_DIR)/lib/udev/vol_id: $(STAGING_DIR)/usr/lib/libvolume_id.la
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(TARGET_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(TARGET_DIR)/usr/lib/libvolume_id.so.0
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(TARGET_DIR)/usr/lib/libvolume_id.so
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/vol_id $(TARGET_DIR)/lib/udev/vol_id

udev-volume_id: udev $(TARGET_DIR)/lib/udev/vol_id

udev-volume_id-clean:
	rm -f $(STAGING_DIR)/usr/include/libvolume_id.h
	rm -f $(STAGING_DIR)/usr/lib/libvolume_id.so*
	rm -f $(STAGING_DIR)/usr/lib/libvolume_id.la
	rm -f $(TARGET_DIR)/usr/lib/libvolume_id.so.0*
	rm -f $(TARGET_DIR)/lib/udev/vol_id
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/lib/udev

udev-volume_id-dirclean:
	-$(MAKE) EXTRAS="extras/volume_id" -C $(UDEV_DIR) clean

UDEV_CLEAN_DEPS+=udev-volume_id-clean
UDEV_DIRCLEAN_DEPS+=udev-volume_id-dirclean
endif

#####################################################################
ifeq ($(BR2_PACKAGE_UDEV_SCSI_ID),y)
.PHONY: udev-scsi_id udev-scsi_id-clean udev-scsi_id-dirclean

$(TARGET_DIR)/lib/udev/scsi_id: $(STAGING_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/scsi_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/scsi_id/scsi_id $(TARGET_DIR)/lib/udev/scsi_id
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/udev/scsi_id

$(TARGET_DIR)/lib/udev/usb_id: $(STAGING_DIR)/usr/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/usb_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/usb_id/usb_id $(TARGET_DIR)/lib/udev/usb_id
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/udev/usb_id

udev-scsi_id: udev $(TARGET_DIR)/lib/udev/scsi_id $(TARGET_DIR)/lib/udev/usb_id

udev-scsi_id-clean:
	rm -f $(TARGET_DIR)/lib/udev/scsi_id
	rm -f $(TARGET_DIR)/lib/udev/usb_id
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/lib/udev

udev-scsi_id-dirclean:
	-$(MAKE) EXTRAS="extras/scsi_id" -C $(UDEV_DIR) clean

UDEV_CLEAN_DEPS+=udev-scsi_id-clean
UDEV_DIRCLEAN_DEPS+=udev-scsi_id-dirclean
endif

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_UDEV),y)
TARGETS+=udev
endif

ifeq ($(BR2_PACKAGE_UDEV_VOLUME_ID),y)
TARGETS+=udev-volume_id
endif

ifeq ($(BR2_PACKAGE_UDEV_SCSI_ID),y)
TARGETS+=udev-scsi_id
endif
