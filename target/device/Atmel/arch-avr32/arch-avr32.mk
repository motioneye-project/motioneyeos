ifeq ($(BR2_avr32),y)

avr32.patched.ac97: $(LINUX26_DIR)/.patched.ac97
	@echo avr32.patched.ac97

avr32.patched.isi: $(LINUX26_DIR)/.patched.isi
	@echo avr32.patched.isi

avr32.patched.psif: $(LINUX26_DIR)/.patched.psif
	@echo avr32.patched.psif


$(LINUX26_DIR)/.patched.isi: $(LINUX26_DIR)/.patched.arch
	toolchain/patch-kernel.sh $(LINUX26_DIR) $(BR2_KERNEL_ARCH_PATCH_DIR) \
		linux-*-500-v4l-avr32-isi.patch.cond
	touch $@

$(LINUX26_DIR)/.patched.ac97: $(LINUX26_DIR)/.patched.arch
	toolchain/patch-kernel.sh $(LINUX26_DIR) $(BR2_KERNEL_ARCH_PATCH_DIR) \
		linux-*-avr32-ac97-reset.patch.cond
	touch $@

$(LINUX26_DIR)/.patched.psif: $(LINUX26_DIR)/.patched.arch
	toolchain/patch-kernel.sh $(LINUX26_DIR) $(BR2_KERNEL_ARCH_PATCH_DIR) \
		linux-*-avr32-psif-2.patch.cond
	touch $@
endif
