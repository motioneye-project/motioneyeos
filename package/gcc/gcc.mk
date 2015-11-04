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
else
GCC_SITE = $(BR2_GNU_MIRROR:/=)/gcc/gcc-$(GCC_VERSION)
endif

GCC_SOURCE ?= gcc-$(GCC_VERSION).tar.bz2

#
# Xtensa special hook
#

HOST_GCC_XTENSA_OVERLAY_TAR = $(BR2_XTENSA_OVERLAY_DIR)/xtensa_$(call qstrip,$(BR2_XTENSA_CORE_NAME)).tar

define HOST_GCC_XTENSA_OVERLAY_EXTRACT
	tar xf $(HOST_GCC_XTENSA_OVERLAY_TAR) -C $(@D) --strip-components=1 gcc
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

define HOST_GCC_APPLY_PATCHES
	if test -d package/gcc/$(GCC_VERSION); then \
	  $(APPLY_PATCHES) $(@D) package/gcc/$(GCC_VERSION) \*.patch ; \
	fi;
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
	--with-mpfr=$(HOST_DIR)/usr \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/"

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
HOST_GCC_COMMON_CONF_ENV = \
	MAKEINFO=missing

GCC_COMMON_TARGET_CFLAGS = $(TARGET_CFLAGS)
GCC_COMMON_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)

# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=43810
# Workaround until it's fixed in 4.5.4 or later
ifeq ($(ARCH),powerpc)
ifeq ($(findstring x4.5.,x$(GCC_VERSION)),x4.5.)
GCC_COMMON_TARGET_CFLAGS = $(filter-out -Os,$(GCC_COMMON_TARGET_CFLAGS))
GCC_COMMON_TARGET_CXXFLAGS = $(filter-out -Os,$(GCC_COMMON_TARGET_CXXFLAGS))
endif
endif

# Xtensa libgcc can't be built with -mauto-litpools
# because of the trick used to generate .init/.fini sections.
ifeq ($(BR2_xtensa),y)
GCC_COMMON_TARGET_CFLAGS = $(filter-out -mauto-litpools,$(TARGET_CFLAGS))
GCC_COMMON_TARGET_CXXFLAGS = $(filter-out -mauto-litpools,$(TARGET_CXXFLAGS))
endif

# Propagate options used for target software building to GCC target libs
HOST_GCC_COMMON_CONF_ENV += CFLAGS_FOR_TARGET="$(GCC_COMMON_TARGET_CFLAGS)"
HOST_GCC_COMMON_CONF_ENV += CXXFLAGS_FOR_TARGET="$(GCC_COMMON_TARGET_CXXFLAGS)"

# libitm needs sparc V9+
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
HOST_GCC_COMMON_CONF_OPTS += --disable-libitm
endif

# gcc 4.6.x quadmath requires wchar
ifneq ($(BR2_TOOLCHAIN_BUILDROOT_WCHAR),y)
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

ifeq ($(BR2_GCC_ENABLE_TLS),y)
HOST_GCC_COMMON_CONF_OPTS += --enable-tls
else
HOST_GCC_COMMON_CONF_OPTS += --disable-tls
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

ifeq ($(BR2_GCC_NEEDS_MPC),y)
HOST_GCC_COMMON_DEPENDENCIES += host-mpc
HOST_GCC_COMMON_CONF_OPTS += --with-mpc=$(HOST_DIR)/usr
endif

ifeq ($(BR2_GCC_ENABLE_GRAPHITE),y)
HOST_GCC_COMMON_DEPENDENCIES += host-isl host-cloog
HOST_GCC_COMMON_CONF_OPTS += --with-isl=$(HOST_DIR)/usr --with-cloog=$(HOST_DIR)/usr
else
HOST_GCC_COMMON_CONF_OPTS += --without-isl --without-cloog
endif

ifeq ($(BR2_arc),y)
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

# Enable proper double/long double for SPE ABI
ifeq ($(BR2_powerpc_SPE),y)
HOST_GCC_COMMON_CONF_OPTS += \
	--enable-e500_double \
	--with-long-double-128
endif

HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CROSS_PATH_SUFFIX='".br_real"'

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
# Cfr. PATCH_BASE_DIRS in .stamp_patched, but we catch both versioned and
# unversioned patches unconditionally
HOST_GCC_COMMON_CCACHE_HASH_FILES += \
	$(sort $(wildcard \
		package/gcc/$(GCC_VERSION)/*.patch \
		$(addsuffix $((PKG)_RAWNAME)/$(GCC_VERSION)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix $((PKG)_RAWNAME)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)))))
ifeq ($(BR2_xtensa),y)
HOST_GCC_COMMON_CCACHE_HASH_FILES += $(HOST_GCC_XTENSA_OVERLAY_TAR)
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
		*cc|*cc-*|*++|*++-*|*cpp) \
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
