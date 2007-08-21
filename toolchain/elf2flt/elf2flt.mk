#############################################################
#
# elf2flt
#
#############################################################

# we keep a local checkout of uClinux CVS
ELF2FLT_SOURCE:=$(ELF2FLT_DIR)/elf2flt
ELF2FLT_DIR:=$(TOOL_BUILD_DIR)/elf2flt
ELF2FLT_BINARY:=elf2flt

$(ELF2FLT_DIR)/.unpacked:
	cp -r toolchain/elf2flt/elf2flt "$(TOOL_BUILD_DIR)/elf2flt"
	touch $@

$(ELF2FLT_DIR)/.patched: $(ELF2FLT_DIR)/.unpacked
ifeq ($(strip $(ARCH)),nios2)
	$(SED) "s,STAGING_DIR,$(STAGING_DIR),g;" toolchain/elf2flt/elf2flt.nios2.conditional
	$(SED) "s,CROSS_COMPILE_PREFIX,$(REAL_GNU_TARGET_NAME),g;" toolchain/elf2flt/elf2flt.nios2.conditional
	toolchain/patch-kernel.sh $(ELF2FLT_DIR) toolchain/elf2flt elf2flt.nios2.conditional
endif
	touch $@

$(ELF2FLT_DIR)/.configured: $(ELF2FLT_DIR)/.patched
	(cd $(ELF2FLT_DIR); rm -rf config.cache; \
		$(ELF2FLT_DIR)/configure \
		--with-bfd-include-dir=$(BINUTILS_DIR1)/bfd/ \
               --with-binutils-include-dir=$(BINUTILS_DIR)/include/ \
		--target=$(REAL_GNU_TARGET_NAME) \
		--with-libbfd=$(BINUTILS_DIR1)/bfd/libbfd.a \
		--with-libiberty=$(BINUTILS_DIR1)/libiberty/libiberty.a \
		--prefix=$(STAGING_DIR))
	touch $@

$(ELF2FLT_DIR)/$(ELF2FLT_BINARY): $(ELF2FLT_DIR)/.configured
	$(MAKE) -C $(ELF2FLT_DIR) all
	$(MAKE) -C $(ELF2FLT_DIR) install

elf2flt: uclibc_target uclibc-configured binutils gcc $(ELF2FLT_DIR)/$(ELF2FLT_BINARY)

elf2flt-clean:
	rm -rf $(ELF2FLT_SOURCE)

elf2flt-dirclean:
	rm -rf $(ELF2FLT_SOURCE)

ifeq ($(strip $(BR2_ELF2FLT)),y)
TARGETS+=elf2flt
endif
