################################################################################
#
# Common variables for the gcc-initial and gcc-final packages.
#
################################################################################

#
# Version, site and source
#

GCC_VERSION = $(call qstrip,$(BR2_GCC_VERSION))

ifeq ($(BR2_arc),y)
GCC_SITE = $(call github,foss-for-synopsys-dwc-arc-processors,gcc,$(GCC_VERSION))
GCC_SOURCE = gcc-$(GCC_VERSION).tar.gz
else ifeq ($(BR2_or1k),y)
GCC_SITE = $(call github,openrisc,or1k-gcc,$(GCC_VERSION))
GCC_SOURCE = gcc-$(GCC_VERSION).tar.gz
else
GCC_SITE = $(BR2_GNU_MIRROR:/=)/gcc/gcc-$(GCC_VERSION)
GCC_SOURCE = gcc-$(GCC_VERSION).tar.bz2
endif

#
# Xtensa special hook
#
define HOST_GCC_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),gcc)
endef

#
# Apply patches
#

ifeq ($(ARCH),powerpc)
ifneq ($(BR2_SOFT_FLOAT),)
define HOST_GCC_APPLY_POWERPC_PATCH
	$(APPLY_PATCHES) $(@D) package/gcc/$(GCC_VERSION) 1000-powerpc-link-with-math-lib.patch.conditional
endef
endif
endif

# gcc is a special package, not named gcc, but gcc-initial and
# gcc-final, but patches are nonetheless stored in package/gcc in the
# tree, and potentially in BR2_GLOBAL_PATCH_DIR directories as well.
define HOST_GCC_APPLY_PATCHES
	for patchdir in \
	    package/gcc/$(GCC_VERSION) \
	    $(addsuffix /gcc/$(GCC_VERSION),$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
	    $(addsuffix /gcc,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) ; do \
		if test -d $${patchdir}; then \
			$(APPLY_PATCHES) $(@D) $${patchdir} \*.patch || exit 1; \
		fi; \
	done
	$(HOST_GCC_APPLY_POWERPC_PATCH)
endef

HOST_GCC_EXCLUDES = \
	libjava/* libgo/* \
	gcc/testsuite/* libstdc++-v3/testsuite/*

define HOST_GCC_FAKE_TESTSUITE
	mkdir -p $(@D)/libstdc++-v3/testsuite/
	echo "all:" > $(@D)/libstdc++-v3/testsuite/Makefile.in
	echo "install:" >> $(@D)/libstdc++-v3/testsuite/Makefile.in
endef

#
# Create 'build' directory and configure symlink
#

define HOST_GCC_CONFIGURE_SYMLINK
	mkdir -p $(@D)/build
	ln -sf ../configure $(@D)/build/configure
endef

#
# Common configuration options
#

HOST_GCC_COMMON_DEPENDENCIES = \
	host-binutils \
	host-gmp \
	host-mpc \
	host-mpfr \
	$(if $(BR2_BINFMT_FLAT),host-elf2flt)

HOST_GCC_COMMON_CONF_OPTS = \
	--target=$(GNU_TARGET_NAME) \
	--with-sysroot=$(STAGING_DIR) \
	--disable-__cxa_atexit \
	--with-gnu-ld \
	--disable-libssp \
	--disable-multilib \
	--with-gmp=$(HOST_DIR)/usr \
	--with-mpc=$(HOST_DIR)/usr \
	--with-mpfr=$(HOST_DIR)/usr \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/"

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
HOST_GCC_COMMON_CONF_ENV = \
	MAKEINFO=missing

GCC_COMMON_TARGET_CFLAGS = $(TARGET_CFLAGS)
GCC_COMMON_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)

# Propagate options used for target software building to GCC target libs
HOST_GCC_COMMON_CONF_ENV += CFLAGS_FOR_TARGET="$(GCC_COMMON_TARGET_CFLAGS)"
HOST_GCC_COMMON_CONF_ENV += CXXFLAGS_FOR_TARGET="$(GCC_COMMON_TARGET_CXXFLAGS)"

# libitm needs sparc V9+
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
HOST_GCC_COMMON_CONF_OPTS += --disable-libitm
endif

# libmpx uses secure_getenv and struct _libc_fpstate not present in musl
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_MUSL)$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),yy)
HOST_GCC_COMMON_CONF_OPTS += --disable-libmpx
endif

# quadmath support requires wchar
ifeq ($(BR2_USE_WCHAR)$(BR2_TOOLCHAIN_HAS_LIBQUADMATH),yy)
HOST_GCC_COMMON_CONF_OPTS += --enable-libquadmath
else
HOST_GCC_COMMON_CONF_OPTS += --disable-libquadmath
endif

# libsanitizer requires wordexp, not in default uClibc config. Also
# doesn't build properly with musl.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_UCLIBC)$(BR2_TOOLCHAIN_BUILDROOT_MUSL),y)
HOST_GCC_COMMON_CONF_OPTS += --disable-libsanitizer
endif

# libsanitizer is broken for SPARC
# https://bugs.busybox.net/show_bug.cgi?id=7951
ifeq ($(BR2_sparc)$(BR2_sparc64),y)
HOST_GCC_COMMON_CONF_OPTS += --disable-libsanitizer
endif

# TLS support is not needed on uClibc/no-thread and
# uClibc/linux-threads, otherwise, for all other situations (glibc,
# musl and uClibc/NPTL), we need it.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_UCLIBC)$(BR2_PTHREADS)$(BR2_PTHREADS_NONE),yy)
HOST_GCC_COMMON_CONF_OPTS += --disable-tls
else
HOST_GCC_COMMON_CONF_OPTS += --enable-tls
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
HOST_GCC_COMMON_CONF_OPTS += --enable-plugins --enable-lto
endif

ifeq ($(BR2_GCC_ENABLE_LIBMUDFLAP),y)
HOST_GCC_COMMON_CONF_OPTS += --enable-libmudflap
else
HOST_GCC_COMMON_CONF_OPTS += --disable-libmudflap
endif

ifeq ($(BR2_PTHREADS_NONE),y)
HOST_GCC_COMMON_CONF_OPTS += \
	--disable-threads \
	--disable-libitm \
	--disable-libatomic
else
HOST_GCC_COMMON_CONF_OPTS += --enable-threads
endif

ifeq ($(BR2_GCC_ENABLE_GRAPHITE),y)
HOST_GCC_COMMON_DEPENDENCIES += host-isl
HOST_GCC_COMMON_CONF_OPTS += --with-isl=$(HOST_DIR)/usr
# gcc 5 doesn't need cloog any more, see
# https://gcc.gnu.org/gcc-5/changes.html
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_5),)
HOST_GCC_COMMON_DEPENDENCIES += host-cloog
HOST_GCC_COMMON_CONF_OPTS += --with-cloog=$(HOST_DIR)/usr
endif
else
HOST_GCC_COMMON_CONF_OPTS += --without-isl --without-cloog
endif

ifeq ($(BR2_arc)$(BR2_or1k),y)
HOST_GCC_COMMON_DEPENDENCIES += host-flex host-bison
endif

ifeq ($(BR2_SOFT_FLOAT),y)
# only mips*-*-*, arm*-*-* and sparc*-*-* accept --with-float
# powerpc seems to be needing it as well
ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_powerpc)$(BR2_sparc),y)
HOST_GCC_COMMON_CONF_OPTS += --with-float=soft
endif
endif

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_GCC_COMMON_CONF_OPTS += --disable-decimal-float
endif

# Determine arch/tune/abi/cpu options
ifeq ($(BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS),y)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ARCH)),)
HOST_GCC_COMMON_CONF_OPTS += --with-arch=$(BR2_GCC_TARGET_ARCH)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ABI)),)
HOST_GCC_COMMON_CONF_OPTS += --with-abi=$(BR2_GCC_TARGET_ABI)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU)),)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
HOST_GCC_COMMON_CONF_OPTS += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
else
HOST_GCC_COMMON_CONF_OPTS += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU))
endif
endif

GCC_TARGET_FPU = $(call qstrip,$(BR2_GCC_TARGET_FPU))
ifneq ($(GCC_TARGET_FPU),)
HOST_GCC_COMMON_CONF_OPTS += --with-fpu=$(GCC_TARGET_FPU)
endif

GCC_TARGET_FLOAT_ABI = $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
ifneq ($(GCC_TARGET_FLOAT_ABI),)
HOST_GCC_COMMON_CONF_OPTS += --with-float=$(GCC_TARGET_FLOAT_ABI)
endif

GCC_TARGET_MODE = $(call qstrip,$(BR2_GCC_TARGET_MODE))
ifneq ($(GCC_TARGET_MODE),)
HOST_GCC_COMMON_CONF_OPTS += --with-mode=$(GCC_TARGET_MODE)
endif
endif # BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS

# Enable proper double/long double for SPE ABI
ifeq ($(BR2_powerpc_SPE),y)
HOST_GCC_COMMON_CONF_OPTS += \
	--enable-e500_double \
	--with-long-double-128
endif

# PowerPC64 big endian by default uses the elfv1 ABI, and PowerPC 64
# little endian by default uses the elfv2 ABI. However, musl has
# decided to use the elfv2 ABI for both, so we force the elfv2 ABI for
# Power64 big endian when the selected C library is musl.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL)$(BR2_powerpc64),yy)
HOST_GCC_COMMON_CONF_OPTS += \
	--with-abi=elfv2 \
	--without-long-double-128
endif

HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CROSS_PATH_SUFFIX='".br_real"'
ifeq ($(BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS),)
ifeq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
HOST_GCC_COMMON_WRAPPER_TARGET_CPU := $(call qstrip,$(BR2_GCC_TARGET_CPU))
else
HOST_GCC_COMMON_WRAPPER_TARGET_CPU := $(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
endif
HOST_GCC_COMMON_WRAPPER_TARGET_ARCH := $(call qstrip,$(BR2_GCC_TARGET_ARCH))
HOST_GCC_COMMON_WRAPPER_TARGET_ABI := $(call qstrip,$(BR2_GCC_TARGET_ABI))
HOST_GCC_COMMON_WRAPPER_TARGET_FPU := $(call qstrip,$(BR2_GCC_TARGET_FPU))
HOST_GCC_COMMON_WRAPPER_TARGET_FLOAT_ABI := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
HOST_GCC_COMMON_WRAPPER_TARGET_MODE := $(call qstrip,$(BR2_GCC_TARGET_MODE))

ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_ARCH),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_ARCH='"$(HOST_GCC_COMMON_WRAPPER_TARGET_ARCH)"'
endif
ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_CPU),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CPU='"$(HOST_GCC_COMMON_WRAPPER_TARGET_CPU)"'
endif
ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_ABI),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_ABI='"$(HOST_GCC_COMMON_WRAPPER_TARGET_ABI)"'
endif
ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_FPU),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_FPU='"$(HOST_GCC_COMMON_WRAPPER_TARGET_FPU)"'
endif
ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_FLOATABI_),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_FLOAT_ABI='"$(HOST_GCC_COMMON_WRAPPER_TARGET_FLOATABI_)"'
endif
ifneq ($(HOST_GCC_COMMON_WRAPPER_TARGET_MODE),)
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_MODE='"$(HOST_GCC_COMMON_WRAPPER_TARGET_MODE)"'
endif
endif # !BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS

# For gcc-initial, we need to tell gcc that the C library will be
# providing the ssp support, as it can't guess it since the C library
# hasn't been built yet.
#
# For gcc-final, the gcc logic to detect whether SSP support is
# available or not in the C library is not working properly for
# uClibc, so let's be explicit as well.
HOST_GCC_COMMON_MAKE_OPTS = \
	gcc_cv_libc_provides_ssp=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)

ifeq ($(BR2_CCACHE),y)
HOST_GCC_COMMON_CCACHE_HASH_FILES += $(DL_DIR)/$(GCC_SOURCE)

# Cfr. PATCH_BASE_DIRS in .stamp_patched, but we catch both versioned
# and unversioned patches unconditionally. Moreover, to facilitate the
# addition of gcc patches in BR2_GLOBAL_PATCH_DIR, we allow them to be
# stored in a sub-directory called 'gcc' even if it's not technically
# the name of the package.
HOST_GCC_COMMON_CCACHE_HASH_FILES += \
	$(sort $(wildcard \
		package/gcc/$(GCC_VERSION)/*.patch \
		$(addsuffix /$($(PKG)_RAWNAME)/$(GCC_VERSION)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /$($(PKG)_RAWNAME)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /gcc/$(GCC_VERSION)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /gcc/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)))))
ifeq ($(BR2_xtensa),y)
HOST_GCC_COMMON_CCACHE_HASH_FILES += $(ARCH_XTENSA_OVERLAY_TAR)
endif
ifeq ($(ARCH),powerpc)
ifneq ($(BR2_SOFT_FLOAT),)
HOST_GCC_COMMON_CCACHE_HASH_FILES += package/gcc/$(GCC_VERSION)/1000-powerpc-link-with-math-lib.patch.conditional
endif
endif

# _CONF_OPTS contains some references to the absolute path of $(HOST_DIR)
# and a reference to the Buildroot git revision (BR2_VERSION_FULL),
# so substitute those away.
HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE_HASH=\"`\
	printf '%s\n' $(subst $(HOST_DIR),@HOST_DIR@,\
		$(subst --with-pkgversion="Buildroot $(BR2_VERSION_FULL)",,$($(PKG)_CONF_OPTS))) \
		| sha256sum - $(HOST_GCC_COMMON_CCACHE_HASH_FILES) \
		| cut -c -64 | tr -d '\n'`\"
endif # BR2_CCACHE

# The LTO support in gcc creates wrappers for ar, ranlib and nm which load
# the lto plugin. These wrappers are called *-gcc-ar, *-gcc-ranlib, and
# *-gcc-nm and should be used instead of the real programs when -flto is
# used. However, we should not add the toolchain wrapper for them, and they
# match the *cc-* pattern. Therefore, an additional case is added for *-ar,
# *-ranlib and *-nm.
# According to gfortran manpage, it supports all options supported by gcc, so
# add gfortran to the list of the program called via the Buildroot wrapper.
# Avoid that a .br_real is symlinked a second time.
# Also create <arch>-linux-<tool> symlinks.
define HOST_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS
	$(Q)cd $(HOST_DIR)/usr/bin; \
	for i in $(GNU_TARGET_NAME)-*; do \
		case "$$i" in \
		*.br_real) \
			;; \
		*-ar|*-ranlib|*-nm) \
			ln -snf $$i $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			;; \
		*cc|*cc-*|*++|*++-*|*cpp|*-gfortran) \
			rm -f $$i.br_real; \
			mv $$i $$i.br_real; \
			ln -sf toolchain-wrapper $$i; \
			ln -sf toolchain-wrapper $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			ln -snf $$i.br_real $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}.br_real; \
			;; \
		*) \
			ln -snf $$i $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			;; \
		esac; \
	done

endef

include $(sort $(wildcard package/gcc/*/*.mk))
