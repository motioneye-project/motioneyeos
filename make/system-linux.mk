#############################################################
#
# System Linux kernel target
#
# This uses an existing linux kernel source tree on
# your build system, and makes no effort at compiling
# anything....
#
# You will probably want to change LINUX_SOURCE to
# point to wherever you installed you kernel.
#
#  -Erik
#
#############################################################
ifneq ($(filter $(TARGETS),system-linux),)

LINUX_SOURCE=/usr/src/linux
LINUX_DIR=$(BUILD_DIR)/linux
LINUX_KERNEL=$(BUILD_DIR)/buildroot-kernel

$(LINUX_DIR)/.configured:
	mkdir -p $(LINUX_DIR)
	(cd $(LINUX_DIR); ln -s $(LINUX_SOURCE)/include)
	touch $(LINUX_DIR)/.configured

$(LINUX_KERNEL): $(LINUX_DIR)/.configured

$(STAGING_DIR)/include/linux/version.h: $(LINUX_DIR)/.configured
	mkdir -p $(STAGING_DIR)/include
	rm -rf $(STAGING_DIR)/include/linux
	cp -dpa $(LINUX_SOURCE)/include/linux $(STAGING_DIR)/include/
	rm -rf $(STAGING_DIR)/include/asm
	mkdir -p $(STAGING_DIR)/include/asm
	cp -dpa $(LINUX_SOURCE)/include/asm/* $(STAGING_DIR)/include/asm/
	rm -rf $(STAGING_DIR)/include/scsi
	mkdir -p $(STAGING_DIR)/include/scsi
	cp -dpa $(LINUX_SOURCE)/include/scsi/* $(STAGING_DIR)/include/scsi
	touch -c $(STAGING_DIR)/include/linux/version.h

system-linux: $(STAGING_DIR)/include/linux/version.h

system-linux-clean: clean
	rm -f $(LINUX_KERNEL)
	rm -rf $(LINUX_DIR)

system-linux-dirclean:
	rm -rf $(LINUX_DIR)

endif
