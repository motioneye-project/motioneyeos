################################################################################
#
# uclibc
#
################################################################################

UCLIBC_VERSION = $(call qstrip,$(BR2_UCLIBC_VERSION_STRING))
UCLIBC_SOURCE ?= uClibc-$(UCLIBC_VERSION).tar.bz2

ifeq ($(BR2_UCLIBC_VERSION_SNAPSHOT),y)
UCLIBC_SITE = http://www.uclibc.org/downloads/snapshots
else ifeq ($(BR2_arc),y)
UCLIBC_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,uClibc,$(UCLIBC_VERSION))
UCLIBC_SOURCE = uClibc-$(UCLIBC_VERSION).tar.gz
else ifeq ($(BR2_UCLIBC_VERSION_XTENSA_GIT),y)
UCLIBC_SITE = git://git.busybox.net/uClibc
UCLIBC_SOURCE = uClibc-$(UCLIBC_VERSION).tar.gz
else
UCLIBC_SITE = http://www.uclibc.org/downloads
UCLIBC_SOURCE = uClibc-$(UCLIBC_VERSION).tar.xz
endif

UCLIBC_INSTALL_STAGING = YES

# uclibc is part of the toolchain so disable the toolchain dependency
UCLIBC_ADD_TOOLCHAIN_DEPENDENCY = NO

# Before uClibc is configured, we must have the first stage
# cross-compiler and the kernel headers
UCLIBC_DEPENDENCIES = host-gcc-initial linux-headers

# specifying UCLIBC_CONFIG_FILE on the command-line overrides the .config
# setting.
ifndef UCLIBC_CONFIG_FILE
UCLIBC_CONFIG_FILE = $(call qstrip,$(BR2_UCLIBC_CONFIG))
endif

UCLIBC_TARGET_ARCH = $(call qstrip,$(BR2_UCLIBC_TARGET_ARCH))

ifeq ($(GENERATE_LOCALE),)
# We need at least one locale
UCLIBC_LOCALES = en_US
else
# Strip out the encoding part of locale names, if any
UCLIBC_LOCALES = $(foreach locale,$(GENERATE_LOCALE),\
		   $(firstword $(subst .,$(space),$(locale))))
endif

#
# Utility functions to manipulation the uClibc configuration file
#

define UCLIBC_OPT_SET
	$(SED) '/$(1)/d' $(3)/.config
	echo '$(1)=$(2)' >> $(3)/.config
endef

define UCLIBC_OPT_UNSET
	$(SED) '/$(1)/d' $(2)/.config
	echo '# $(1) is not set' >> $(2)/.config
endef

#
# ARM definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),arm)
UCLIBC_ARM_TYPE = CONFIG_$(call qstrip,$(BR2_UCLIBC_ARM_TYPE))

define UCLIBC_ARM_TYPE_CONFIG
	$(SED) 's/^\(CONFIG_[^_]*[_]*ARM[^=]*\)=.*/# \1 is not set/g' \
		$(@D)/.config
	$(call UCLIBC_OPT_SET,$(UCLIBC_ARM_TYPE),y,$(@D))
endef

define UCLIBC_ARM_ABI_CONFIG
	$(SED) '/CONFIG_ARM_.ABI/d' $(@D)/.config
	$(call UCLIBC_OPT_SET,CONFIG_ARM_EABI,y,$(@D))
endef

# Thumb build is broken with threads, build in ARM mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
UCLIBC_EXTRA_CFLAGS += -marm
endif

ifeq ($(BR2_UCLIBC_ARM_BX),y)
define UCLIBC_ARM_BX_CONFIG
	$(call UCLIBC_OPT_SET,USE_BX,y,$(@D))
endef
else
define UCLIBC_ARM_BX_CONFIG
	$(call UCLIBC_OPT_UNSET,USE_BX,$(@D))
endef
endif

endif # arm

#
# MIPS definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),mips)
UCLIBC_MIPS_ABI = CONFIG_MIPS_$(call qstrip,$(BR2_UCLIBC_MIPS_ABI))_ABI
define UCLIBC_MIPS_ABI_CONFIG
	$(SED) '/CONFIG_MIPS_[NO].._ABI/d' $(@D)/.config
	$(call UCLIBC_OPT_SET,$(UCLIBC_MIPS_ABI),y,$(@D))
endef

UCLIBC_MIPS_ISA = CONFIG_MIPS_ISA_$(call qstrip,$(BR2_UCLIBC_MIPS_ISA))
define UCLIBC_MIPS_ISA_CONFIG
	$(SED) '/CONFIG_MIPS_ISA_.*/d' $(@D)/.config
	$(call UCLIBC_OPT_SET,$(UCLIBC_MIPS_ISA),y,$(@D))
endef
endif # mips

#
# SH definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),sh)
UCLIBC_SH_TYPE = CONFIG_$(call qstrip,$(BR2_UCLIBC_SH_TYPE))
define UCLIBC_SH_TYPE_CONFIG
	$(SED) '/CONFIG_SH[234A]*/d' $(@D)/.config
	$(call UCLIBC_OPT_SET,$(UCLIBC_SH_TYPE),y,$(@D))
endef
endif # sh

#
# SPARC definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),sparc)
UCLIBC_SPARC_TYPE = CONFIG_SPARC_$(call qstrip,$(BR2_UCLIBC_SPARC_TYPE))
define UCLIBC_SPARC_TYPE_CONFIG
	$(SED) 's/^\(CONFIG_[^_]*[_]*SPARC[^=]*\)=.*/# \1 is not set/g' \
		 $(@D)/.config
	$(call UCLIBC_OPT_SET,$(UCLIBC_SPARC_TYPE),y,$(@D))
endef
endif # sparc

#
# PowerPC definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),powerpc)
UCLIBC_POWERPC_TYPE = CONFIG_$(call qstrip,$(BR2_UCLIBC_POWERPC_TYPE))
define UCLIBC_POWERPC_TYPE_CONFIG
	$(call UCLIBC_OPT_UNSET,CONFIG_GENERIC,$(@D))
	$(call UCLIBC_OPT_UNSET,CONFIG_E500,$(@D))
	$(call UCLIBC_OPT_SET,$(UCLIBC_POWERPC_TYPE),y,$(@D))
endef
endif # powerpc

#
# Blackfin definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),bfin)
ifeq ($(BR2_BINFMT_FDPIC),y)
define UCLIBC_BFIN_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT_SEP_DATA,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_SHARED_FLAT,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_FORMAT_FDPIC_ELF,y,$(@D))
endef
endif
ifeq ($(BR2_BINFMT_FLAT_ONE),y)
define UCLIBC_BFIN_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_FORMAT_FLAT,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT_SEP_DATA,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_SHARED_FLAT,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FDPIC_ELF,$(@D))
endef
endif
ifeq ($(BR2_BINFMT_FLAT_SEP_DATA),y)
define UCLIBC_BFIN_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_FORMAT_FLAT_SEP_DATA,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_SHARED_FLAT,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FDPIC_ELF,$(@D))
endef
endif
ifeq ($(BR2_BINFMT_FLAT_SHARED),y)
define UCLIBC_BFIN_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FLAT_SEP_DATA,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_FORMAT_SHARED_FLAT,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_FORMAT_FDPIC_ELF,$(@D))
endef
endif
endif # bfin

#
# AVR32 definitions
#

ifeq ($(UCLIBC_TARGET_ARCH),avr32)
define UCLIBC_AVR32_CONFIG
	$(call UCLIBC_OPT_SET,LINKRELAX,y,$(@D))
endef
endif # avr32

#
# x86 definitions
#
ifeq ($(UCLIBC_TARGET_ARCH),i386)
UCLIBC_X86_TYPE = CONFIG_$(call qstrip,$(BR2_UCLIBC_X86_TYPE))
define UCLIBC_X86_TYPE_CONFIG
	$(call UCLIBC_OPT_SET,$(UCLIBC_X86_TYPE),y,$(@D))
endef
endif

#
# Endianness
#

ifeq ($(call qstrip,$(BR2_ENDIAN)),BIG)
define UCLIBC_ENDIAN_CONFIG
	$(call UCLIBC_OPT_SET,ARCH_BIG_ENDIAN,y,$(@D))
	$(call UCLIBC_OPT_SET,ARCH_WANTS_BIG_ENDIAN,y,$(@D))
	$(call UCLIBC_OPT_UNSET,ARCH_LITTLE_ENDIAN,$(@D))
	$(call UCLIBC_OPT_UNSET,ARCH_WANTS_LITTLE_ENDIAN,$(@D))
endef
else
define UCLIBC_ENDIAN_CONFIG
	$(call UCLIBC_OPT_SET,ARCH_LITTLE_ENDIAN,y,$(@D))
	$(call UCLIBC_OPT_SET,ARCH_WANTS_LITTLE_ENDIAN,y,$(@D))
	$(call UCLIBC_OPT_UNSET,ARCH_BIG_ENDIAN,$(@D))
	$(call UCLIBC_OPT_UNSET,ARCH_WANTS_BIG_ENDIAN,$(@D))
endef
endif

#
# Largefile
#

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_LARGEFILE),y)
define UCLIBC_LARGEFILE_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_LFS,y,$(@D))
endef
else
define UCLIBC_LARGEFILE_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_LFS,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_FOPEN_LARGEFILE_MODE,$(@D))
endef
endif

#
# MMU
#

ifeq ($(BR2_USE_MMU),y)
define UCLIBC_MMU_CONFIG
	$(call UCLIBC_OPT_SET,ARCH_USE_MMU,y,$(@D))
endef
else
define UCLIBC_MMU_CONFIG
	$(call UCLIBC_OPT_UNSET,ARCH_USE_MMU,$(@D))
endef
endif

#
# IPv6
#

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_INET_IPV6),y)
UCLIBC_IPV6_CONFIG = $(call UCLIBC_OPT_SET,UCLIBC_HAS_IPV6,y,$(@D))
else
UCLIBC_IPV6_CONFIG = $(call UCLIBC_OPT_UNSET,UCLIBC_HAS_IPV6,$(@D))
endif

#
# RPC
#

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_INET_RPC),y)
define UCLIBC_RPC_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_RPC,y,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_FULL_RPC,y,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_REENTRANT_RPC,y,$(@D))
endef
else
define UCLIBC_RPC_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_RPC,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_FULL_RPC,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_REENTRANT_RPC,$(@D))
endef
endif

#
# soft-float
#

ifeq ($(BR2_SOFT_FLOAT),y)
define UCLIBC_FLOAT_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_FPU,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_FLOATS,y,$(@D))
	$(call UCLIBC_OPT_SET,DO_C99_MATH,y,$(@D))
endef
else
define UCLIBC_FLOAT_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_FPU,y,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_FLOATS,y,$(@D))
endef
endif

#
# SSP
#
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_USE_SSP),y)
define UCLIBC_SSP_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_SSP,y,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_BUILD_SSP,y,$(@D))
endef
else
define UCLIBC_SSP_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_SSP,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_BUILD_SSP,$(@D))
endef
endif

#
# Threads
#
ifeq ($(BR2_PTHREADS_NONE),y)
define UCLIBC_THREAD_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_THREADS,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS_OLD,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_THREADS_NATIVE,$(@D))
endef
else ifeq ($(BR2_PTHREADS),y)
define UCLIBC_THREAD_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_THREADS,y,$(@D))
	$(call UCLIBC_OPT_SET,LINUXTHREADS_NEW,y,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS_OLD,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_THREADS_NATIVE,$(@D))
endef
else ifeq ($(BR2_PTHREADS_OLD),y)
define UCLIBC_THREAD_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_THREADS,y,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS_NEW,$(@D))
	$(call UCLIBC_OPT_SET,LINUXTHREADS_OLD,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_THREADS_NATIVE,$(@D))
endef
else ifeq ($(BR2_PTHREADS_NATIVE),y)
define UCLIBC_THREAD_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_THREADS,y,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS_NEW,$(@D))
	$(call UCLIBC_OPT_UNSET,LINUXTHREADS_OLD,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_THREADS_NATIVE,y,$(@D))
endef
endif

#
# Thread debug
#

ifeq ($(BR2_PTHREAD_DEBUG),y)
UCLIBC_THREAD_DEBUG_CONFIG = $(call UCLIBC_OPT_SET,PTHREADS_DEBUG_SUPPORT,y,$(@D))
else
UCLIBC_THREAD_DEBUG_CONFIG = $(call UCLIBC_OPT_UNSET,PTHREADS_DEBUG_SUPPORT,$(@D))
endif

#
# Locale
#

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_LOCALE),y)
define UCLIBC_LOCALE_CONFIG
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_LOCALE,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_BUILD_ALL_LOCALE,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_BUILD_MINIMAL_LOCALE,y,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_BUILD_MINIMAL_LOCALES,"$(UCLIBC_LOCALES)",$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_PREGENERATED_LOCALE_DATA,$(@D))
	$(call UCLIBC_OPT_UNSET,DOWNLOAD_PREGENERATED_LOCALE_DATA,$(@D))
	$(call UCLIBC_OPT_SET,UCLIBC_HAS_XLOCALE,y,$(@D))
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_GLIBC_DIGIT_GROUPING,$(@D))
endef
else
define UCLIBC_LOCALE_CONFIG
	$(call UCLIBC_OPT_UNSET,UCLIBC_HAS_LOCALE,$(@D))
endef
endif

#
# wchar
#

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_WCHAR),y)
UCLIBC_WCHAR_CONFIG = $(call UCLIBC_OPT_SET,UCLIBC_HAS_WCHAR,y,$(@D))
else
UCLIBC_WCHAR_CONFIG = $(call UCLIBC_OPT_UNSET,UCLIBC_HAS_WCHAR,$(@D))
endif

#
# strip
#

ifeq ($(BR2_STRIP_none),y)
UCLIBC_STRIP_CONFIG = $(call UCLIBC_OPT_UNSET,DOSTRIP,$(@D))
else
UCLIBC_STRIP_CONFIG = $(call UCLIBC_OPT_SET,DOSTRIP,y,$(@D))
endif

#
# Commands
#

UCLIBC_MAKE_FLAGS = \
	ARCH="$(UCLIBC_TARGET_ARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	UCLIBC_EXTRA_CFLAGS="$(UCLIBC_EXTRA_CFLAGS) $(TARGET_ABI)" \
	HOSTCC="$(HOSTCC)"

define UCLIBC_SETUP_DOT_CONFIG
	$(INSTALL) -m 0644 $(UCLIBC_CONFIG_FILE) $(@D)/.config
	$(call UCLIBC_OPT_SET,CROSS_COMPILER_PREFIX,"$(TARGET_CROSS)",$(@D))
	$(call UCLIBC_OPT_SET,TARGET_$(UCLIBC_TARGET_ARCH),y,$(@D))
	$(call UCLIBC_OPT_SET,TARGET_ARCH,"$(UCLIBC_TARGET_ARCH)",$(@D))
	$(call UCLIBC_OPT_SET,KERNEL_HEADERS,"$(STAGING_DIR)/usr/include",$(@D))
	$(call UCLIBC_OPT_SET,RUNTIME_PREFIX,"/",$(@D))
	$(call UCLIBC_OPT_SET,DEVEL_PREFIX,"/usr",$(@D))
	$(call UCLIBC_OPT_SET,SHARED_LIB_LOADER_PREFIX,"/lib",$(@D))
	$(UCLIBC_MMU_CONFIG)
	$(UCLIBC_ARM_TYPE_CONFIG)
	$(UCLIBC_ARM_ABI_CONFIG)
	$(UCLIBC_ARM_BX_CONFIG)
	$(UCLIBC_MIPS_ABI_CONFIG)
	$(UCLIBC_MIPS_ISA_CONFIG)
	$(UCLIBC_SH_TYPE_CONFIG)
	$(UCLIBC_SPARC_TYPE_CONFIG)
	$(UCLIBC_POWERPC_TYPE_CONFIG)
	$(UCLIBC_AVR32_CONFIG)
	$(UCLIBC_BFIN_CONFIG)
	$(UCLIBC_X86_TYPE_CONFIG)
	$(UCLIBC_ENDIAN_CONFIG)
	$(UCLIBC_LARGEFILE_CONFIG)
	$(UCLIBC_IPV6_CONFIG)
	$(UCLIBC_RPC_CONFIG)
	$(UCLIBC_FLOAT_CONFIG)
	$(UCLIBC_SSP_CONFIG)
	$(UCLIBC_THREAD_CONFIG)
	$(UCLIBC_THREAD_DEBUG_CONFIG)
	$(UCLIBC_LOCALE_CONFIG)
	$(UCLIBC_WCHAR_CONFIG)
	$(UCLIBC_STRIP_CONFIG)
	yes "" | $(MAKE1) -C $(@D) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX=$(STAGING_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(STAGING_DIR) \
		oldconfig
endef

define UCLIBC_CONFIGURE_CMDS
	$(UCLIBC_SETUP_DOT_CONFIG)
	$(MAKE1) -C $(UCLIBC_DIR) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX=$(STAGING_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(STAGING_DIR) \
		headers startfiles \
		install_headers install_startfiles
	$(TARGET_CROSS)gcc -nostdlib \
		-nostartfiles -shared -x c /dev/null -o $(STAGING_DIR)/usr/lib/libc.so
	$(TARGET_CROSS)gcc -nostdlib \
		-nostartfiles -shared -x c /dev/null -o $(STAGING_DIR)/usr/lib/libm.so
endef

ifeq ($(BR2_UCLIBC_INSTALL_TEST_SUITE),y)
define UCLIBC_BUILD_TEST_SUITE
	$(MAKE1) -C $(@D)/test \
		$(UCLIBC_MAKE_FLAGS) \
		ARCH_CFLAGS=-I$(STAGING_DIR)/usr/include \
		UCLIBC_ONLY=1 \
		TEST_INSTALLED_UCLIBC=1 \
		compile
endef
endif

define UCLIBC_BUILD_CMDS
	$(MAKE1) -C $(@D) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX= \
		DEVEL_PREFIX=/ \
		RUNTIME_PREFIX=/ \
		all
	$(MAKE1) -C $(@D)/utils \
		PREFIX=$(HOST_DIR) \
		HOSTCC="$(HOSTCC)" hostutils
	$(UCLIBC_BUILD_TEST_SUITE)
endef

ifeq ($(BR2_UCLIBC_INSTALL_TEST_SUITE),y)
define UCLIBC_INSTALL_TEST_SUITE
	mkdir -p $(TARGET_DIR)/root/uClibc
	cp -rdpf $(@D)/test $(TARGET_DIR)/root/uClibc
	$(INSTALL) -D -m 0644 $(@D)/Rules.mak $(TARGET_DIR)/root/uClibc/Rules.mak
	$(INSTALL) -D -m 0644 $(@D)/.config $(TARGET_DIR)/root/uClibc/.config
endef
endif

ifeq ($(BR2_UCLIBC_INSTALL_UTILS),y)
define UCLIBC_INSTALL_UTILS_TARGET
	$(MAKE1) -C $(@D) \
		CC="$(TARGET_CC)" CPP="$(TARGET_CPP)" LD="$(TARGET_LD)" \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TARGET_DIR) \
		utils install_utils
endef
endif

define UCLIBC_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_runtime
	$(UCLIBC_INSTALL_UTILS_TARGET)
	$(UCLIBC_INSTALL_TEST_SUITE)
endef

# For FLAT binfmts (static) there are no host utils
ifeq ($(BR2_BINFMT_FLAT),)
define UCLIBC_INSTALL_UTILS_STAGING
	$(INSTALL) -D -m 0755 $(@D)/utils/ldd.host $(HOST_DIR)/usr/bin/ldd
	ln -sf ldd $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-ldd
	$(INSTALL) -D -m 0755 $(@D)/utils/ldconfig.host $(HOST_DIR)/usr/bin/ldconfig
	ln -sf ldconfig $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-ldconfig
endef
endif

define UCLIBC_INSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX=$(STAGING_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_runtime install_dev
	$(UCLIBC_INSTALL_UTILS_STAGING)
endef

uclibc-menuconfig: uclibc-patch
	$(MAKE1) -C $(UCLIBC_DIR) \
		$(UCLIBC_MAKE_FLAGS) \
		PREFIX=$(STAGING_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(STAGING_DIR)/ \
		menuconfig
	rm -f $(UCLIBC_DIR)/.stamp_{configured,built,target_installed,staging_installed}

$(eval $(generic-package))

uclibc-update-config: $(UCLIBC_DIR)/.stamp_configured
	cp -f $(UCLIBC_DIR)/.config $(UCLIBC_CONFIG_FILE)

# Before uClibc is built, we must have the second stage cross-compiler
$(UCLIBC_TARGET_BUILD): | host-gcc-intermediate
