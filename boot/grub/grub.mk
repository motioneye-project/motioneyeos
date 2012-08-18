#############################################################
#
# grub
#
#############################################################

GRUB_VERSION = 0.97
GRUB_SOURCE = grub_$(GRUB_VERSION).orig.tar.gz
GRUB_PATCH  = grub_$(GRUB_VERSION)-35.diff.gz
GRUB_SITE   = http://snapshot.debian.org/archive/debian/20080329T000000Z/pool/main/g/grub/

GRUB_LICENSE = GPLv2+
GRUB_LICENSE_FILES = COPYING

GRUB_CFLAGS=-DSUPPORT_LOOPDEV
ifeq ($(BR2_LARGEFILE),)
GRUB_CFLAGS+=-U_FILE_OFFSET_BITS
endif

GRUB_CONFIG-$(BR2_TARGET_GRUB_SPLASH) += --enable-graphics
GRUB_CONFIG-$(BR2_TARGET_GRUB_DISKLESS) += --enable-diskless
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c595) += --enable-3c595
GRUB_CONFIG-$(BR2_TARGET_GRUB_3c90x) += --enable-3c90x
GRUB_CONFIG-$(BR2_TARGET_GRUB_davicom) += --enable-davicom
GRUB_CONFIG-$(BR2_TARGET_GRUB_e1000) += --enable-e1000
GRUB_CONFIG-$(BR2_TARGET_GRUB_eepro100) += --enable-eepro100
GRUB_CONFIG-$(BR2_TARGET_GRUB_epic100) += --enable-epic100
GRUB_CONFIG-$(BR2_TARGET_GRUB_forcedeth) += --enable-forcedeth
GRUB_CONFIG-$(BR2_TARGET_GRUB_natsemi) += --enable-natsemi
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns83820) += --enable-ns83820
GRUB_CONFIG-$(BR2_TARGET_GRUB_ns8390) += --enable-ns8390
GRUB_CONFIG-$(BR2_TARGET_GRUB_pcnet32) += --enable-pcnet32
GRUB_CONFIG-$(BR2_TARGET_GRUB_pnic) += --enable-pnic
GRUB_CONFIG-$(BR2_TARGET_GRUB_rtl8139) += --enable-rtl8139
GRUB_CONFIG-$(BR2_TARGET_GRUB_r8169) += --enable-r8169
GRUB_CONFIG-$(BR2_TARGET_GRUB_sis900) += --enable-sis900
GRUB_CONFIG-$(BR2_TARGET_GRUB_tg3) += --enable-tg3
GRUB_CONFIG-$(BR2_TARGET_GRUB_tulip) += --enable-tulip
GRUB_CONFIG-$(BR2_TARGET_GRUB_tlan) += --enable-tlan
GRUB_CONFIG-$(BR2_TARGET_GRUB_undi) += --enable-undi
GRUB_CONFIG-$(BR2_TARGET_GRUB_via_rhine) += --enable-via-rhine
GRUB_CONFIG-$(BR2_TARGET_GRUB_w89c840) += --enable-w89c840

define GRUB_DEBIAN_PATCHES
	# Apply the patches from the Debian patch
	(cd $(@D) ; for f in `cat debian/patches/00list | grep -v ^#` ; do \
		cat debian/patches/$$f | patch -g0 -p1 ; \
	done)
endef

GRUB_POST_PATCH_HOOKS += GRUB_DEBIAN_PATCHES

GRUB_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) $(GRUB_CFLAGS)"

GRUB_CONF_OPT = \
	--disable-auto-linux-mem-opt \
	$(GRUB_CONFIG-y)

define GRUB_INSTALL_STAGING_CMDS
	install -m 0755 -D $(@D)/grub/grub $(STAGING_DIR)/sbin/grub
endef

ifeq ($(BR2_TARGET_GRUB_SPLASH),y)
define GRUB_INSTALL_SPLASH
	cp boot/grub/splash.xpm.gz $(TARGET_DIR)/boot/grub/
endef
endif

define GRUB_INSTALL_TARGET_CMDS
	install -m 0755 -D $(@D)/grub/grub $(TARGET_DIR)/sbin/grub
	mkdir -p $(TARGET_DIR)/boot/grub
	cp $(@D)/stage1/stage1 $(TARGET_DIR)/boot/grub
	cp $(@D)/stage2/*1_5   $(TARGET_DIR)/boot/grub
	cp $(@D)/stage2/stage2 $(TARGET_DIR)/boot/grub
	$(GRUB_INSTALL_SPLASH)
endef

define GRUB_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/sbin/grub
endef

define GRUB_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/grub
	rm -rf $(TARGET_DIR)/boot/grub
endef

$(eval $(autotools-package))
