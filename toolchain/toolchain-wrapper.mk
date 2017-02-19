# This file contains the definition of the toolchain wrapper build commands

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

# We create a list like '"-mfoo", "-mbar", "-mbarfoo"' so that each flag is a
# separate argument when used in execv() by the toolchain wrapper.
TOOLCHAIN_WRAPPER_OPTS = \
	$(foreach f,$(call qstrip,$(BR2_TARGET_OPTIMIZATION)),"$(f)"$(comma))
TOOLCHAIN_WRAPPER_ARGS += -DBR_ADDITIONAL_CFLAGS='$(TOOLCHAIN_WRAPPER_OPTS)'

ifeq ($(BR2_CCACHE),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE
endif

ifeq ($(BR2_x86_x1000),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_OMIT_LOCK_PREFIX
endif

# Avoid FPU bug on XBurst CPUs
ifeq ($(BR2_mips_xburst),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_NO_FUSED_MADD
endif

ifeq ($(BR2_CCACHE_USE_BASEDIR),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE_BASEDIR='"$(BASE_DIR)"'
endif

define TOOLCHAIN_WRAPPER_BUILD
	$(HOSTCC) $(HOST_CFLAGS) $(TOOLCHAIN_WRAPPER_ARGS) \
		-s -Wl,--hash-style=$(TOOLCHAIN_WRAPPER_HASH_STYLE) \
		toolchain/toolchain-wrapper.c \
		-o $(@D)/toolchain-wrapper
endef

define TOOLCHAIN_WRAPPER_INSTALL
	$(INSTALL) -D -m 0755 $(@D)/toolchain-wrapper \
		$(HOST_DIR)/usr/bin/toolchain-wrapper
endef
