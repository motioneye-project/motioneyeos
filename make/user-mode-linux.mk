#############################################################
#
# Linux kernel targets
#
#############################################################
UMLINUX_DIR=$(BUILD_DIR)/linux
UMLINUX_SOURCE=linux-2.4.18.tar.bz2
UMLINUX_SITE=http://ftp.us.kernel.org/pub/linux/kernel/v2.4
UMLINUX_PATCH_1:=uml-patch-2.4.18-19.bz2
UMLINUX_PATCH_1_SITE:=http://prdownloads.sourceforge.net/user-mode-linux
UMLINUX_KCONFIG=$(SOURCE_DIR)/linux-uml.config

$(DL_DIR)/$(UMLINUX_SOURCE):
	wget -P $(DL_DIR) --passive-ftp $(UMLINUX_SITE)/$(UMLINUX_SOURCE)

$(DL_DIR)/$(UMLINUX_PATCH_1):
	wget -P $(DL_DIR) --passive-ftp $(UMLINUX_PATCH_1_SITE)/$(UMLINUX_PATCH_1)

user-mode-linux-source: $(DL_DIR)/$(UMLINUX_SOURCE) $(DL_DIR)/$(UMLINUX_PATCH_1)

$(UMLINUX_DIR)/.unpacked: $(DL_DIR)/$(UMLINUX_SOURCE) $(DL_DIR)/$(UMLINUX_PATCH_1)
	bzcat $(DL_DIR)/$(UMLINUX_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(UMLINUX_DIR)/.unpacked

$(UMLINUX_DIR)/.patched: $(UMLINUX_DIR)/.unpacked
	bzcat $(DL_DIR)/$(UMLINUX_PATCH_1) | patch -d $(UMLINUX_DIR) -p1
	touch $(UMLINUX_DIR)/.patched

$(UMLINUX_DIR)/.set_arch: $(UMLINUX_DIR)/.patched
	perl -i -p -e "s/^ARCH :=.*/ARCH:=um/g;" $(UMLINUX_DIR)/Makefile
	touch $(UMLINUX_DIR)/.set_arch

$(UMLINUX_DIR)/.config: $(UMLINUX_DIR)/.set_arch
	cp $(UMLINUX_KCONFIG) $(UMLINUX_DIR)/.config
	make -C $(UMLINUX_DIR) oldconfig
	touch -c $(UMLINUX_DIR)/.config

$(UMLINUX_DIR)/linux: $(UMLINUX_DIR)/.config
	make -C $(UMLINUX_DIR) dep
	make -C $(UMLINUX_DIR) linux

$(LINUX_KERNEL): $(UMLINUX_DIR)/linux
	cp -fa $(UMLINUX_DIR)/linux $(LINUX_KERNEL)

user-mode-linux: $(LINUX_KERNEL)

# Renamed so it is not cleaned by default on a make clean
user-mode-linux_clean: clean
	rm -f $(LINUX_KERNEL)
	-make -C $(UMLINUX_DIR) clean

user-mode-linux-dirclean:
	rm -rf $(UMLINUX_DIR)

