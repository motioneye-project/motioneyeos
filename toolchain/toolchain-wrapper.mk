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

ifeq ($(BR2_CCACHE_USE_BASEDIR),y)
TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE_BASEDIR='"$(BASE_DIR)"'
endif

# For simplicity, build directly into the install location
define TOOLCHAIN_BUILD_WRAPPER
	$(Q)mkdir -p $(HOST_DIR)/usr/bin
	$(HOSTCC) $(HOST_CFLAGS) $(TOOLCHAIN_WRAPPER_ARGS) \
		-s -Wl,--hash-style=$(TOOLCHAIN_WRAPPER_HASH_STYLE) \
		toolchain/toolchain-wrapper.c \
		-o $(HOST_DIR)/usr/bin/toolchain-wrapper
endef
