################################################################################
#
# sysvinit
#
################################################################################

SYSVINIT_VERSION = 2.88
SYSVINIT_SOURCE  = sysvinit_$(SYSVINIT_VERSION)dsf.orig.tar.gz
SYSVINIT_PATCH   = sysvinit_$(SYSVINIT_VERSION)dsf-13.1.diff.gz
SYSVINIT_SITE    = $(BR2_DEBIAN_MIRROR)/debian/pool/main/s/sysvinit
SYSVINIT_LICENSE = GPLv2+
SYSVINIT_LICENSE_FILES = COPYING

# Override BusyBox implementations if BusyBox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSVINIT_DEPENDENCIES = busybox
endif

define SYSVINIT_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

SYSVINIT_POST_PATCH_HOOKS = SYSVINIT_DEBIAN_PATCHES

define SYSVINIT_BUILD_CMDS
	# Force sysvinit to link against libcrypt as it otherwise
	# use an incorrect test to see if it's available
	$(MAKE) $(TARGET_CONFIGURE_OPTS) SULOGINLIBS="-lcrypt" -C $(@D)/src
endef

define SYSVINIT_INSTALL_TARGET_CMDS
	for x in halt init shutdown killall5; do \
		$(INSTALL) -D -m 0755 $(@D)/src/$$x $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
	# Override BusyBox's inittab with an inittab compatible with
	# sysvinit
	$(INSTALL) -D -m 0644 package/sysvinit/inittab $(TARGET_DIR)/etc/inittab
	ln -sf /sbin/halt $(TARGET_DIR)/sbin/reboot
	ln -sf /sbin/halt $(TARGET_DIR)/sbin/poweroff
	ln -sf killall5 $(TARGET_DIR)/sbin/pidof
endef

$(eval $(generic-package))
