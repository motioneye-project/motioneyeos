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
UDEV_INSTALL_STAGING=YES

# 094 had _GNU_SOURCE set
BR2_UDEV_CFLAGS:= -D_GNU_SOURCE $(TARGET_CFLAGS)
ifeq ($(BR2_LARGEFILE),)
BR2_UDEV_CFLAGS+=-U_FILE_OFFSET_BITS
endif

# UDEV_ROOT is /dev so we can replace devfs, not /udev for experiments
UDEV_ROOT:=/dev

UDEV_EXTRAS=
ifeq ($(BR2_PACKAGE_UDEV_VOLUME_ID),y)
UDEV_EXTRAS+=volume_id
endif
ifeq ($(BR2_PACKAGE_UDEV_SCSI_ID),y)
UDEV_EXTRAS+=scsi_id
UDEV_EXTRAS+=usb_id
endif
ifeq ($(BR2_PACKAGE_UDEV_PATH_ID),y)
UDEV_EXTRAS+=path_id
endif
ifeq ($(BR2_PACKAGE_UDEV_FIRMWARE_SH),y)
UDEV_EXTRAS+=firmware
endif

UDEV_BUILD_EXTRAS=$(addprefix extras/,$(UDEV_EXTRAS))

#
# Build
#
define UDEV_BUILD_CMDS
	$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) CC="$(TARGET_CC)" LD="$(TARGET_CC)"\
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="$(UDEV_BUILD_EXTRAS)" -C $(@D)
endef

#
# Staging installation
#
ifeq ($(BR2_PACKAGE_UDEV_VOLUME_ID),y)
define UDEV_VOLUME_ID_STAGING_INSTALL_CMDS
	$(INSTALL) -m 0644 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.h $(STAGING_DIR)/usr/include/libvolume_id.h
	$(INSTALL) -m 0755 -D $(UDEV_DIR)/extras/volume_id/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/lib/libvolume_id.so.$(UDEV_VOLUME_ID_VERSION)
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/lib/libvolume_id.so.0
	-ln -sf libvolume_id.so.$(UDEV_VOLUME_ID_VERSION) $(STAGING_DIR)/lib/libvolume_id.so
	$(INSTALL) -m 0755 -D package/udev/libvolume_id.la.tmpl $(STAGING_DIR)/lib/libvolume_id.la
	$(SED) 's/REPLACE_CURRENT/$(UDEV_VOLUME_ID_CURRENT)/g' $(STAGING_DIR)/lib/libvolume_id.la
	$(SED) 's/REPLACE_AGE/$(UDEV_VOLUME_ID_AGE)/g' $(STAGING_DIR)/lib/libvolume_id.la
	$(SED) 's/REPLACE_REVISION/$(UDEV_VOLUME_ID_REVISION)/g' $(STAGING_DIR)/lib/libvolume_id.la
	$(SED) 's,REPLACE_LIB_DIR,$(STAGING_DIR)/usr/lib,g' $(STAGING_DIR)/lib/libvolume_id.la
endef
endif

define UDEV_INSTALL_STAGING_CMDS
$(UDEV_VOLUME_ID_STAGING_INSTALL_CMDS)
endef

#
# Target installation
#
ifneq ($(BR2_PACKAGE_UDEV_UTILS),y)
define UDEV_UTILS_REMOVAL
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor
	rm -f $(TARGET_DIR)/usr/bin/udevinfo
	rm -f $(TARGET_DIR)/usr/bin/udevtest
endef
endif

define UDEV_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/sys
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		CFLAGS="$(BR2_UDEV_CFLAGS)" \
		LDFLAGS="-warn-common" \
		USE_LOG=false USE_SELINUX=false \
		udevdir=$(UDEV_ROOT) EXTRAS="$(UDEV_BUILD_EXTRAS)" -C $(@D) install
	$(INSTALL) -m 0755 -D package/udev/S10udev $(TARGET_DIR)/etc/init.d/S10udev
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/etc/udev/rules.d
	$(INSTALL) -m 0644 $(@D)/etc/udev/frugalware/* $(TARGET_DIR)/etc/udev/rules.d
	( grep udev_root $(TARGET_DIR)/etc/udev/udev.conf > /dev/null 2>&1 || echo 'udev_root=/dev' >> $(TARGET_DIR)/etc/udev/udev.conf )
	install -m 0755 -D $(@D)/udevstart $(TARGET_DIR)/sbin/udevstart
	for i in $(TARGET_DIR)/sbin/udev* $(TARGET_DIR)/usr/bin/udev* ; do \
		$(STRIPCMD) $(STRIP_STRIP_ALL) $$i ; \
	done
	for i in scsi_id usb_id vol_id ; do \
		if test -e $(TARGET_DIR)/lib/udev/$$i ; then \
			$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/lib/udev/$$i ; \
		fi \
	done
	$(UDEV_UTILS_REMOVAL)
endef

#
# Clean
#
define UDEV_CLEAN_CMDS
	-$(MAKE) EXTRAS="$(UDEV_BUILD_EXTRAS)" -C $(@D) clean
endef

#
# Staging uninstall
#
define UDEV_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/include/libvolume_id.h
	rm -f $(STAGING_DIR)/lib/libvolume_id.so*
	rm -f $(STAGING_DIR)/lib/libvolume_id.la
endef

#
# Target uninstall
#
define UDEV_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/etc/init.d/S10udev $(TARGET_DIR)/sbin/udev*
	rm -f $(TARGET_DIR)/usr/sbin/udevmonitor $(TARGET_DIR)/usr/bin/udev*
	rm -fr $(TARGET_DIR)/sys
	rm -f $(TARGET_DIR)/lib/libvolume_id.so.0*
	rm -rf $(TARGET_DIR)/lib/udev
endef

$(eval $(call GENTARGETS,package,udev))
