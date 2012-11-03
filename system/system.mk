TARGET_GENERIC_HOSTNAME:=$(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
TARGET_GENERIC_ISSUE:=$(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
TARGET_GENERIC_GETTY:=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT))
TARGET_GENERIC_GETTY_BAUDRATE:=$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE))

target-generic-hostname:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts

target-generic-issue:
	mkdir -p $(TARGET_DIR)/etc
	echo "$(TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue

target-generic-getty-busybox:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(TARGET_GENERIC_GETTY)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY) $(TARGET_GENERIC_GETTY_BAUDRATE) vt100 #~' \
		$(TARGET_DIR)/etc/inittab

# In sysvinit inittab, the "id" must not be longer than 4 bytes, so we
# skip the "tty" part and keep only the remaining.
target-generic-getty-sysvinit:
	$(SED) '/# GENERIC_SERIAL$$/s~^.*#~$(shell echo $(TARGET_GENERIC_GETTY) | tail -c+4)::respawn:/sbin/getty -L $(TARGET_GENERIC_GETTY) $(TARGET_GENERIC_GETTY_BAUDRATE) vt100 #~' \
		$(TARGET_DIR)/etc/inittab

# Find commented line, if any, and remove leading '#'s
target-generic-do-remount-rw:
	$(SED) '/^#.*# REMOUNT_ROOTFS_RW$$/s~^#\+~~' $(TARGET_DIR)/etc/inittab

# Find uncommented line, if any, and add a leading '#'
target-generic-dont-remount-rw:
	$(SED) '/^[^#].*# REMOUNT_ROOTFS_RW$$/s~^~#~' $(TARGET_DIR)/etc/inittab

ifneq ($(TARGET_GENERIC_HOSTNAME),)
TARGETS += target-generic-hostname
endif

ifneq ($(TARGET_GENERIC_ISSUE),)
TARGETS += target-generic-issue
endif

ifeq ($(BR2_ROOTFS_SKELETON_DEFAULT),y)
ifeq ($(BR2_PACKAGE_SYSVINIT),y)
TARGETS += target-generic-getty-sysvinit
else
TARGETS += target-generic-getty-busybox
endif
ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
TARGETS += target-generic-do-remount-rw
else
TARGETS += target-generic-dont-remount-rw
endif
endif
