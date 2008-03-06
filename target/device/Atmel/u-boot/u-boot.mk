#############################################################
#
# U-Boot
#
#############################################################
U_BOOT_VERSION:=1.3.0
U_BOOT_SOURCE:=u-boot-$(U_BOOT_VERSION).tar.bz2
U_BOOT_SITE:=ftp://ftp.denx.de/pub/u-boot
U_BOOT_DIR:=$(PROJECT_BUILD_DIR)/u-boot-$(U_BOOT_VERSION)
U_BOOT_CAT:=$(BZCAT)
U_BOOT_BIN:=u-boot.bin
U_BOOT_TOOLS_BIN:=mkimage

U_BOOT_INC_CONF_FILE:=$(U_BOOT_DIR)/include/configs/$(subst _config,,$(BR2_TARGET_U_BOOT_CONFIG_BOARD)).h

$(DL_DIR)/$(U_BOOT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(U_BOOT_SITE)/$(U_BOOT_SOURCE)

$(U_BOOT_DIR)/.unpacked: $(DL_DIR)/$(U_BOOT_SOURCE)
	$(U_BOOT_CAT) $(DL_DIR)/$(U_BOOT_SOURCE) \
		| tar -C $(PROJECT_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(U_BOOT_DIR) target/device/Atmel/u-boot/ \
		u-boot-$(U_BOOT_VERSION)-\*.patch\*
	touch $@

$(U_BOOT_DIR)/.header_copied: $(U_BOOT_DIR)/.unpacked
ifneq ($(BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE),"")
	@if [ ! -f "$(BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE)" ]; then	\
		echo "	You specified BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE,"; \
		echo "	but the file at:";				\
		echo "	'$(BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE)'";	\
		echo "	does not exist.";				\
		echo;							\
		echo "	Configure the BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE variable."; \
		echo;							\
		exit 1;							\
	fi
	cp -dpf $(BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE) $(U_BOOT_INC_CONF_FILE)
endif
	touch $@

$(U_BOOT_DIR)/.configured: $(U_BOOT_DIR)/.header_copied
ifeq ($(strip $(BR2_TARGET_U_BOOT_CONFIG_BOARD)),"")
	@echo
	@echo "	You did not specify a target u-boot config board, so u-boot"
	@echo "	has no way of knowing which board you want to build your"
	@echo "	bootloader for."
	@echo
	@echo "	Configure the BR2_TARGET_U_BOOT_CONFIG_BOARD variable."
	@echo
	@exit 1
endif
	$(TARGET_CONFIGURE_OPTS)		\
		CFLAGS="$(TARGET_CFLAGS)"	\
		LDFLAGS="$(TARGET_LDFLAGS)"	\
		$(MAKE) -C $(U_BOOT_DIR)	\
		$(BR2_TARGET_U_BOOT_CONFIG_BOARD)
	touch $@

$(U_BOOT_DIR)/.header_modified: $(U_BOOT_DIR)/.configured
	# Modify configuration header in $(U_BOOT_INC_CONF_FILE)
	@echo >> $(U_BOOT_INC_CONF_FILE)
	@echo "/* Add a wrapper around the values Buildroot sets. */" >> $(U_BOOT_INC_CONF_FILE)
	@echo "#ifndef __BR2_ADDED_CONFIG_H" >> $(U_BOOT_INC_CONF_FILE)
	@echo "#define __BR2_ADDED_CONFIG_H" >> $(U_BOOT_INC_CONF_FILE)
ifneq ($(strip $(BR2_PROJECT)),"")
	@echo "#define CONFIG_HOSTNAME" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_HOSTNAME.*,#define CONFIG_HOSTNAME	$(subst ",,$(BR2_PROJECT)),' $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_SERVERIP)),"")
	@echo "#define CONFIG_SERVERIP" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_SERVERIP.*,#define CONFIG_SERVERIP	$(subst ",,$(BR2_TARGET_U_BOOT_SERVERIP)),' $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_IPADDR)),"")
	@echo "#define CONFIG_IPADDR" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_IPADDR.*,#define CONFIG_IPADDR	$(subst ",,$(BR2_TARGET_U_BOOT_IPADDR)),' $(U_BOOT_INC_CONF_FILE)
ifneq ($(strip $(BR2_TARGET_U_BOOT_GATEWAY)),"")
	@echo "#define CONFIG_GATEWAYIP" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_GATEWAYIP.*,#define CONFIG_GATEWAYIP	$(subst ",,$(BR2_TARGET_U_BOOT_GATEWAY)),' $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_NETMASK)),"")
	@echo "#define CONFIG_NETMASK" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_NETMASK.*,#define CONFIG_NETMASK	$(subst ",,$(BR2_TARGET_U_BOOT_NETMASK)),' $(U_BOOT_INC_CONF_FILE)
endif
endif # end BR2_TARGET_U_BOOT_IPADDR
ifneq ($(strip $(BR2_TARGET_U_BOOT_ETH0ADDR)),"")
	@echo "#define CONFIG_ETHADDR" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_ETHADDR.*,#define CONFIG_ETHADDR	$(subst ",,$(BR2_TARGET_U_BOOT_ETH0ADDR)),' $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_ETH1ADDR)),"")
	@echo "#define CONFIG_ETH1ADDR" >> $(U_BOOT_INC_CONF_FILE)
	$(SED) 's,^#define.*CONFIG_ETH1ADDR.*,#define CONFIG_ETH1ADDR	$(subst ",,$(BR2_TARGET_U_BOOT_ETH1ADDR)),' $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_BOOTARGS)),"")
	@echo "#undef CONFIG_BOOTARGS" >> $(U_BOOT_INC_CONF_FILE)
	@echo '#define CONFIG_BOOTARGS $(BR2_TARGET_U_BOOT_BOOTARGS)' >> $(U_BOOT_INC_CONF_FILE)
endif
ifneq ($(strip $(BR2_TARGET_U_BOOT_BOOTCMD)),"")
	@echo "#undef CONFIG_BOOTCOMMAND" >> $(U_BOOT_INC_CONF_FILE)
	@echo '#define CONFIG_BOOTCOMMAND $(BR2_TARGET_U_BOOT_BOOTCMD)' >> $(U_BOOT_INC_CONF_FILE)
endif
	@echo "#endif /* __BR2_ADDED_CONFIG_H */" >> $(U_BOOT_INC_CONF_FILE)
	touch $@

$(U_BOOT_DIR)/$(U_BOOT_BIN): $(U_BOOT_DIR)/.header_modified
	$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		$(MAKE) -C $(U_BOOT_DIR)

$(BINARIES_DIR)/$(U_BOOT_BIN): $(U_BOOT_DIR)/$(U_BOOT_BIN)
	cp -dpf $(U_BOOT_DIR)/$(U_BOOT_BIN) $(BINARIES_DIR)
	cp -dpf $(U_BOOT_DIR)/tools/$(U_BOOT_TOOLS_BIN) $(STAGING_DIR)/usr/bin/

u-boot: gcc $(BINARIES_DIR)/$(U_BOOT_BIN)

u-boot-clean:
	$(MAKE) -C $(U_BOOT_DIR) clean

u-boot-dirclean:
	rm -rf $(U_BOOT_DIR)

u-boot-source: $(DL_DIR)/$(U_BOOT_SOURCE)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_TARGET_U_BOOT)),y)
TARGETS+=u-boot
endif

u-boot-status:
	@echo
	@echo U_BOOT_INC_CONF_FILE = $(U_BOOT_INC_CONF_FILE)
	@echo
	@echo BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE = $(BR2_TARGET_U_BOOT_CONFIG_HEADER_FILE)
	@echo BR2_TARGET_U_BOOT_CONFIG_BOARD = $(BR2_TARGET_U_BOOT_CONFIG_BOARD)
	@echo BR2_TARGET_U_BOOT_SERVERIP = $(BR2_TARGET_U_BOOT_SERVERIP)
	@echo BR2_TARGET_U_BOOT_IPADDR = $(BR2_TARGET_U_BOOT_IPADDR)
	@echo BR2_TARGET_U_BOOT_GATEWAY = $(BR2_TARGET_U_BOOT_GATEWAY)
	@echo BR2_TARGET_U_BOOT_NETMASK = $(BR2_TARGET_U_BOOT_NETMASK)
	@echo BR2_TARGET_U_BOOT_ETH0ADDR = $(BR2_TARGET_U_BOOT_ETH0ADDR)
	@echo BR2_TARGET_U_BOOT_ETH1ADDR = $(BR2_TARGET_U_BOOT_ETH1ADDR)
	@echo BR2_TARGET_U_BOOT_BOOTARGS = $(BR2_TARGET_U_BOOT_BOOTARGS)
	@echo BR2_TARGET_U_BOOT_BOOTCMD = $(BR2_TARGET_U_BOOT_BOOTCMD)
	@echo
	@exit 0
