################################################################################
#
# ljsyscall
#
################################################################################

LJSYSCALL_VERSION = v0.9
LJSYSCALL_SITE = $(call github,justincormack,ljsyscall,$(LJSYSCALL_VERSION))
LJSYSCALL_LICENSE = MIT
LJSYSCALL_LICENSE_FILES = COPYRIGHT

ifeq ($(BR2_i386),y)
LJSYSCALL_ARCH = x86
else ifeq ($(BR2_x86_64),y)
LJSYSCALL_ARCH = x64
else ifeq ($(BR2_powerpc),y)
LJSYSCALL_ARCH = ppc
else ifeq ($(LJSYSCALL_ARCH),)
LJSYSCALL_ARCH = $(BR2_ARCH)
endif

LJSYSCALL_TARGET_DIR = $(TARGET_DIR)/usr/share/luajit-$(LUAJIT_VERSION)

define LJSYSCALL_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(LJSYSCALL_TARGET_DIR)/syscall
	$(INSTALL) -m 0644 -t $(LJSYSCALL_TARGET_DIR)/ $(@D)/syscall.lua
	$(INSTALL) -m 0644 -t $(LJSYSCALL_TARGET_DIR)/syscall $(@D)/syscall/*.lua

	$(INSTALL) -d $(LJSYSCALL_TARGET_DIR)/syscall/linux/$(LJSYSCALL_ARCH)
	$(INSTALL) -m 0644 -t $(LJSYSCALL_TARGET_DIR)/syscall/linux/ $(@D)/syscall/linux/*.lua
	$(INSTALL) -m 0644 -t $(LJSYSCALL_TARGET_DIR)/syscall/linux/$(LJSYSCALL_ARCH) $(@D)/syscall/linux/$(LJSYSCALL_ARCH)/*.lua

	$(INSTALL) -d $(LJSYSCALL_TARGET_DIR)/syscall/shared
	$(INSTALL) -m 0644 -t $(LJSYSCALL_TARGET_DIR)/syscall/shared/ $(@D)/syscall/shared/*.lua
endef

$(eval $(generic-package))
