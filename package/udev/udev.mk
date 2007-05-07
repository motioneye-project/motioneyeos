#############################################################
#
# udev
#
#############################################################
UDEV_VERSION:=101
UDEV_SOURCE:=udev-$(UDEV_VERSION).tar.bz2
UDEV_SITE:=ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
UDEV_CAT:=$(BZCAT)
UDEV_DIR:=$(BUILD_DIR)/udev-$(UDEV_VERSION)
UDEV_TARGET_BINARY:=sbin/udevd
UDEV_BINARY:=udev

# 094 had _GNU_SOURCE set
BR2_UDEV_CFLAGS:= -D_GNU_SOURCE $(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),)
BR2_UDEV_CFLAGS+=-U_FILE_OFFSET_BITS
endif


# UDEV_ROOT is /dev so we can replace devfs, not /udev for experiments
UDEV_ROOT:=/dev

$(DL_DIR)/$(UDEV_SOURCE):
	 $(WGET) -P $(DL_DIR) $(UDEV_SITE)/$(UDEV_SOURCE)

udev-source: $(DL_DIR)/$(UDEV_SOURCE)

$(UDEV_DIR)/.unpacked: $(DL_DIR)/$(UDEV_SOURCE)
	$(UDEV_CAT) $(DL_DIR)/$(UDEV_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(UDEV_DIR) package/udev \*.patch
	touch $@

$(UDEV_DIR)/$(UDEV_BINARY): $(UDEV_DIR)/.unpacked
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) CC=$(TARGET_CC) LD=$(TARGET_CC)\
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR)
	touch -c $(UDEV_DIR)/$(UDEV_BINARY)

$(TARGET_DIR)/$(UDEV_TARGET_BINARY): $(UDEV_DIR)/$(UDEV_BINARY)
	-mkdir $(TARGET_DIR)/sys
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) DESTDIR=$(TARGET_DIR) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		LDFLAGS="-warn-common" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) -C $(UDEV_DIR) install
	$(INSTALL) -m 0755 -D package/udev/init-udev $(TARGET_DIR)/etc/init.d/S10udev
	rm -rf $(TARGET_DIR)/usr/share/man
ifneq ($(strip $(BR2_PACKAGE_UDEV_UTILS)),y)
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor
	rm -f $(TARGET_DIR)/usr/bin/udevinfo
	rm -f $(TARGET_DIR)/usr/bin/udevtest
endif

udev: uclibc $(TARGET_DIR)/$(UDEV_TARGET_BINARY)

ifeq ($(strip $(BR2_PACKAGE_UDEV_VOLUME_ID)),y)
$(STAGING_DIR)/usr/lib/libvolume_id.so.0.72.0:
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/volume_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0644 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.h $(STAGING_DIR)/include/libvolume_id.h
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.so.0.72.0 $(STAGING_DIR)/usr/lib/libvolume_id.so.0.72.0
	-ln -sf libvolume_id.so.0.72.0 $(STAGING_DIR)/usr/lib/libvolume_id.so.0
	-ln -sf libvolume_id.so.0 $(STAGING_DIR)/usr/lib/libvolume_id.so

$(TARGET_DIR)/lib/udev/vol_id: $(STAGING_DIR)/usr/lib/libvolume_id.so.0.72.0
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/vol_id $(TARGET_DIR)/lib/udev/vol_id
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.so.0.72.0 $(TARGET_DIR)/usr/lib/libvolume_id.so.0.72.0
	-ln -sf libvolume_id.so.0.72.0 $(TARGET_DIR)/usr/lib/libvolume_id.so.0
	$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libvolume_id.so.0.72.0

udev-volume_id: udev $(TARGET_DIR)/lib/udev/vol_id

udev-volume_id-clean:
	rm -f $(STAGING_DIR)/include/libvolume_id.h
	rm -f $(STAGING_DIR)/usr/lib/libvolume_id.so*
	rm -f $(TARGET_DIR)/usr/lib/libvolume_id.so.0*
	rm -f $(TARGET_DIR)/lib/udev/vol_id
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/lib/udev

udev-volume_id-dirclean:
	-$(MAKE) EXTRAS="extras/volume_id" -C $(UDEV_DIR) clean
endif

ifeq ($(strip $(BR2_PACKAGE_UDEV_SCSI_ID)),y)
$(TARGET_DIR)/lib/udev/scsi_id: $(STAGING_DIR)/usr/lib/libvolume_id.so.0.72.0
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/scsi_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/scsi_id/scsi_id $(TARGET_DIR)/lib/udev/scsi_id
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/udev/scsi_id
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="extras/usb_id" -C $(UDEV_DIR)
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/usb_id/usb_id $(TARGET_DIR)/lib/udev/usb_id
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/udev/usb_id

udev-scsi_id: udev $(TARGET_DIR)/lib/udev/scsi_id

udev-scsi_id-clean:
	rm -f $(TARGET_DIR)/lib/udev/scsi_id

udev-scsi_id-dirclean:
	-$(MAKE) EXTRAS="extras/scsi_id" -C $(UDEV_DIR) clean
endif

udev-clean: udev-volume_id-clean udev-scsi_id-clean
	rm -f $(TARGET_DIR)/etc/init.d/S10udev $(TARGET_DIR)/sbin/udev*
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor $(TARGET_DIR)/usr/bin/udev*
	rmdir $(TARGET_DIR)/sys
	-$(MAKE) -C $(UDEV_DIR) clean

udev-dirclean: udev-volume_id-dirclean udev-scsi_id-dirclean
	rm -rf $(UDEV_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_UDEV)),y)
TARGETS+=udev
endif

ifeq ($(strip $(BR2_PACKAGE_UDEV_VOLUME_ID)),y)
TARGETS+=udev-volume_id
endif

ifeq ($(strip $(BR2_PACKAGE_UDEV_SCSI_ID)),y)
TARGETS+=udev-scsi_id
endif
