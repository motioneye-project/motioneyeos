#############################################################
#
# elf2flt
#
#############################################################

# we keep a local checkout of uClinux CVS
ELF2FLT_SOURCE:=$(ELF2FLT_DIR)/elf2flt
ELF2FLT_DIR:=$(TOOLCHAIN_DIR)/elf2flt
ELF2FLT_BINARY:=elf2flt

$(ELF2FLT_DIR)/.unpacked:
	cp -r toolchain/elf2flt/elf2flt "$(TOOLCHAIN_DIR)/elf2flt"
	touch $@

$(ELF2FLT_DIR)/.patched: $(ELF2FLT_DIR)/.unpacked
	$(call CONFIG_UPDATE,$(@D))
	touch $@

$(ELF2FLT_DIR)/.configured: $(ELF2FLT_DIR)/.patched
	(cd $(ELF2FLT_DIR); rm -rf config.cache; \
		LDFLAGS=-lz \
		$(ELF2FLT_DIR)/configure $(QUIET) \
		--with-bfd-include-dir=$(HOST_BINUTILS_DIR)/bfd/ \
		--with-binutils-include-dir=$(HOST_BINUTILS_DIR)/include/ \
		--target=$(GNU_TARGET_NAME) \
		--with-libbfd=$(HOST_BINUTILS_DIR)/bfd/libbfd.a \
		--with-libiberty=$(HOST_BINUTILS_DIR)/libiberty/libiberty.a \
		--prefix=$(HOST_DIR)/usr)
	touch $@

$(ELF2FLT_DIR)/$(ELF2FLT_BINARY): $(ELF2FLT_DIR)/.configured
	$(MAKE) -C $(ELF2FLT_DIR) all
	$(MAKE) -C $(ELF2FLT_DIR) install

elf2flt: uclibc_target uclibc-configured binutils gcc $(ELF2FLT_DIR)/$(ELF2FLT_BINARY)

elf2flt-clean:
	rm -rf $(ELF2FLT_SOURCE)

elf2flt-dirclean:
	rm -rf $(ELF2FLT_SOURCE)

ifeq ($(BR2_ELF2FLT),y)
TARGETS+=elf2flt
endif
