################################################################################
#
# sysvinit
#
################################################################################

SYSVINIT_VERSION = 2.88
SYSVINIT_SOURCE = sysvinit_$(SYSVINIT_VERSION)dsf.orig.tar.gz
SYSVINIT_PATCH = sysvinit_$(SYSVINIT_VERSION)dsf-13.1+squeeze1.diff.gz
SYSVINIT_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/s/sysvinit
SYSVINIT_LICENSE = GPL-2.0+
SYSVINIT_LICENSE_FILES = COPYING

SYSVINIT_MAKE_OPTS = SYSROOT=$(STAGING_DIR)

# Override BusyBox implementations if BusyBox is enabled.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
SYSVINIT_DEPENDENCIES = busybox
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
SYSVINIT_DEPENDENCIES += libselinux
SYSVINIT_MAKE_OPTS += WITH_SELINUX="yes"
endif

define SYSVINIT_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		$(APPLY_PATCHES) $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

SYSVINIT_POST_PATCH_HOOKS = SYSVINIT_DEBIAN_PATCHES

define SYSVINIT_BUILD_CMDS
	# Force sysvinit to link against libcrypt as it otherwise
	# use an incorrect test to see if it's available
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(SYSVINIT_MAKE_OPTS) -C $(@D)/src
endef

define SYSVINIT_INSTALL_TARGET_CMDS
	for x in halt init shutdown killall5; do \
		$(INSTALL) -D -m 0755 $(@D)/src/$$x $(TARGET_DIR)/sbin/$$x || exit 1; \
	done
	$(INSTALL) -D -m 0644 package/sysvinit/inittab $(TARGET_DIR)/etc/inittab
	ln -sf /sbin/halt $(TARGET_DIR)/sbin/reboot
	ln -sf /sbin/halt $(TARGET_DIR)/sbin/poweroff
	ln -sf killall5 $(TARGET_DIR)/sbin/pidof
endef

ifeq ($(BR2_TARGET_GENERIC_GETTY),y)
define SYSVINIT_SET_GETTY
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(shell echo $(SYSTEM_GETTY_PORT) | tail -c+4)::respawn:/sbin/getty -L $(SYSTEM_GETTY_OPTIONS) $(SYSTEM_GETTY_PORT) $(SYSTEM_GETTY_BAUDRATE) $(SYSTEM_GETTY_TERM) #~' \
		$(TARGET_DIR)/etc/inittab
endef
SYSVINIT_TARGET_FINALIZE_HOOKS += SYSVINIT_SET_GETTY
endif # BR2_TARGET_GENERIC_GETTY

$(eval $(generic-package))
