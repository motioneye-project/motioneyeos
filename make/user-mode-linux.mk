#############################################################
#
# Linux kernel targets
#
#############################################################
ifneq ($(filter $(TARGETS),user-mode-linux),)

LINUX_VERSION=2.4.20
LINUX_DIR=$(BUILD_DIR)/linux-$(LINUX_VERSION)
LINUX_SOURCE=linux-$(LINUX_VERSION).tar.bz2
LINUX_SITE=http://ftp.us.kernel.org/pub/linux/kernel/v2.4
LINUX_PATCH_1:=uml-patch-$(LINUX_VERSION)-5.bz2
LINUX_PATCH_1_SITE:=http://telia.dl.sourceforge.net/sourceforge/user-mode-linux
LINUX_KCONFIG=$(SOURCE_DIR)/linux-uml.config
LINUX_KERNEL=$(BASE_DIR)/UMlinux
# Used by pcmcia-cs and others
LINUX_SOURCE_DIR=$(LINUX_DIR)

$(DL_DIR)/$(LINUX_SOURCE):
	$(WGET) -P $(DL_DIR) $(LINUX_SITE)/$(LINUX_SOURCE)

$(DL_DIR)/$(LINUX_PATCH_1):
	$(WGET) -P $(DL_DIR) $(LINUX_PATCH_1_SITE)/$(LINUX_PATCH_1)

user-mode-linux-source: $(DL_DIR)/$(LINUX_SOURCE) $(DL_DIR)/$(LINUX_PATCH_1)

$(LINUX_DIR)/.unpacked: $(DL_DIR)/$(LINUX_SOURCE) $(DL_DIR)/$(LINUX_PATCH_1)
	bzcat $(DL_DIR)/$(LINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	rm -rf $(BUILD_DIR)/linux
	-(cd $(BUILD_DIR); ln -sf $(LINUX_DIR) linux)
	touch $(LINUX_DIR)/.unpacked

$(LINUX_DIR)/.patched: $(LINUX_DIR)/.unpacked
	bzcat $(DL_DIR)/$(LINUX_PATCH_1) | patch -d $(LINUX_DIR) -p1
	touch $(LINUX_DIR)/.patched

$(LINUX_DIR)/.set_arch: $(LINUX_DIR)/.patched
	perl -i -p -e "s/^ARCH :=.*/ARCH:=um/g;" $(LINUX_DIR)/Makefile
	touch $(LINUX_DIR)/.set_arch

$(LINUX_DIR)/.configured $(BUILD_DIR)/linux/.configured:  $(LINUX_DIR)/.set_arch  $(LINUX_KCONFIG)
	cp $(LINUX_KCONFIG) $(LINUX_DIR)/.config
	$(MAKE) -C $(LINUX_DIR) oldconfig include/linux/version.h
	touch $(LINUX_DIR)/.configured

$(LINUX_DIR)/.depend_done:  $(LINUX_DIR)/.configured
	$(MAKE) -C $(LINUX_DIR) dep
	touch $(LINUX_DIR)/.depend_done

$(LINUX_DIR)/linux: $(LINUX_DIR)/.depend_done
	$(MAKE) -C $(LINUX_DIR) linux

$(LINUX_KERNEL): $(LINUX_DIR)/linux
	cp -fa $(LINUX_DIR)/linux $(LINUX_KERNEL)

user-mode-linux: $(LINUX_KERNEL)

# Renamed so it is not cleaned by default on a make clean
user-mode-linux_clean: clean
	rm -f $(LINUX_KERNEL)
	-$(MAKE) -C $(LINUX_DIR) clean

user-mode-linux-dirclean:
	rm -rf $(LINUX_DIR)

endif
