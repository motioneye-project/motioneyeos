################################################################################
#
# definition of the toolchain wrapper build commands
#
################################################################################

# We use --hash-style=both to increase the compatibility of the generated
# binary with older platforms, except for MIPS, where the only acceptable
# hash style is 'sysv'
ifeq ($(findstring mips,$(HOSTARCH)),mips)
TOOLCHAIN_WRAPPER_HASH_STYLE = sysv
else
TOOLCHAIN_WRAPPER_HASH_STYLE = both
endif

TOOLCHAIN_WRAPPER_ARGS = $($(PKG)_TOOLCHAIN_WRAPPER_ARGS)
TOOLCHAIN_WRAPPER_ARGS += -DBR_SYSROOT='"$(STAGING_SUBDIR)"'

TOOLCHAIN_WRAPPER_OPTS = \
	$(ARCH_TOOLCHAIN_WRAPPER_OPTS) \
	$(call qstrip,$(BR2_SSP_OPTION)) \
	$(call qstrip,$(BR2_TARGET_OPTIMIZATION))

ifeq ($(BR2_REPRODUCIBLE),y)
TOOLCHAIN_WRAPPER_OPTS += -Wl,--build-id=none
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_8),y)
TOOLCHAIN_WRAPPER_OPTS += -ffile-prefix-map=$(BASE_DIR)=buildroot
else
TOOLCHAIN_WRAPPER_OPTS += -D__FILE__=\"\" -D__BASE_FILE__=\"\" -Wno-builtin-macro-redefined
endif
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_7),)
TOOLCHAIN_WRAPPER_OPTS += -DBR_NEED_SOURCE_DATE_EPOCH
endif
endif

# We create a list like '"-mfoo", "-mbar", "-mbarfoo"' so that each flag is a
# separate argument when used in execv() by the toolchain wrapper.
TOOLCHAIN_WRAPPER_ARGS += \
	-DBR_ADDITIONAL_CFLAGS='$(foreach f,$(TOOLCHAIN_WRAPPER_OPTS),"$(f)"$(comma))'

ifeq ($(BR2_CCACHE),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE
endif

ifeq ($(BR2_x86_x1000),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_OMIT_LOCK_PREFIX
endif

# Avoid FPU bug on XBurst CPUs
ifeq ($(BR2_mips_xburst),y)
# Before gcc 4.6, -mno-fused-madd was needed, after -ffp-contract is
# needed
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_6),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_FP_CONTRACT_OFF
else
TOOLCHAIN_WRAPPER_ARGS += -DBR_NO_FUSED_MADD
endif
endif

ifeq ($(BR2_CCACHE_USE_BASEDIR),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE_BASEDIR='"$(BASE_DIR)"'
endif

ifeq ($(BR2_PIC_PIE),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR2_PIC_PIE
endif

ifeq ($(BR2_RELRO_PARTIAL),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR2_RELRO_PARTIAL
else ifeq ($(BR2_RELRO_FULL),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR2_RELRO_FULL
endif

define TOOLCHAIN_WRAPPER_BUILD
	$(HOSTCC) $(HOST_CFLAGS) $(TOOLCHAIN_WRAPPER_ARGS) \
		-s -Wl,--hash-style=$(TOOLCHAIN_WRAPPER_HASH_STYLE) \
		toolchain/toolchain-wrapper.c \
		-o $(@D)/toolchain-wrapper
endef

define TOOLCHAIN_WRAPPER_INSTALL
	$(INSTALL) -D -m 0755 $(@D)/toolchain-wrapper \
		$(HOST_DIR)/bin/toolchain-wrapper
endef
