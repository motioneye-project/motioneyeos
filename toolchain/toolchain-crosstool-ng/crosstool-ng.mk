# Makefile fragment for building toolchain with crosstool-NG

# As a reference, you can look at toolchain/toolchain-external/ext-tool.mk
# for a generic approach to external toolchains.
# crosstool-NG as a backend is but a kind of external toolchains,
# except that it is not pre-built.

#-----------------------------------------------------------------------------
# Internal variables

CTNG_DIR := $(BUILD_DIR)/build-toolchain

CTNG_UCLIBC_CONFIG_FILE := $(TOPDIR)/package/uclibc/uClibc-0.9.33.config
CTNG_CONFIG_FILE := $(call qstrip,$(BR2_TOOLCHAIN_CTNG_CONFIG))

# Hack! ct-ng is in fact a Makefile script. As such, it accepts all
# make options, such as -C, which makes it uneeded to chdir prior
# to calling ct-ng.
# $1: the set of arguments to pass to ct-ng
define ctng
PATH=$(HOST_PATH) ct-ng -C $(CTNG_DIR) --no-print-directory $(1)
endef

#-----------------------------------------------------------------------------
toolchain-crosstool-ng: dependencies $(STAMP_DIR)/ct-ng-toolchain-installed

# The target used by the infra structure to mean "we just want to
# download the toolchain's sources, not build it" For crosstool-NG, we
# need it to be configured before we can download; then we have to
# override a config option to just do the download
toolchain-crosstool-ng-source: $(CTNG_DIR)/.config
	$(Q)$(call ctng,build CT_ONLY_DOWNLOAD=y)

#-----------------------------------------------------------------------------
# Installing the libs to target/ and staging/

#--------------
# The generic system libraries (in /lib)
CTNG_LIBS_LIB := ld*.so libc.so libcrypt.so libdl.so libgcc_s.so libm.so    \
                 libnsl.so libpthread.so libresolv.so librt.so libutil.so

ifeq ($(BR2_PACKAGE_GDB_SERVER),y)
CTNG_LIBS_LIB += libthread_db.so
endif

#--------------
# The libc-specific system libraries (in /lib)
# Note: it may be needed to tweak the NSS libs in the glibc and eglibc cases...
CTNG_LIBS_uClibc :=
CTNG_LIBS_glibc  := libnss_files.so libnss_dns.so
CTNG_LIBS_eglibc := $(CTNG_LIBS_glibc)

#--------------
# All that we need in /lib
CTNG_LIBS_LIB += $(CTNG_LIBS_$(call qstrip,$(BR2_TOOLCHAIN_CTNG_LIBC)))

#--------------
# All that we need in /usr/lib
ifneq ($(BR2_INSTALL_LIBSTDCPP),)
CTNG_LIBS_USR_LIB += libstdc++.so
endif

#--------------
# Actual copy
$(STAMP_DIR)/ct-ng-toolchain-installed: $(STAMP_DIR)/ct-ng-toolchain-built
	$(Q)mkdir -p $(TARGET_DIR)/lib
	$(Q)CTNG_TUPLE="$$( $(call ctng,show-tuple 2>&1) )";                \
	    CTNG_SYSROOT="$(HOST_DIR)/usr/$${CTNG_TUPLE}/sysroot";          \
	    $(call MESSAGE,"Copying toolchain libraries to target...");     \
	    for libs in $(CTNG_LIBS_LIB); do                                \
	        $(call copy_toolchain_lib_root,$${CTNG_SYSROOT},,lib,$$libs,/lib); \
	    done;                                                           \
	    for libs in $(CTNG_LIBS_USR_LIB); do                            \
	        $(call copy_toolchain_lib_root,$${CTNG_SYSROOT},,lib,$$libs,/usr/lib); \
	    done;
	$(Q)touch $@

#-----------------------------------------------------------------------------
# Building the toolchain
# Note: $(STAMP_DIR)/ct-ng-toolchain-built can have more dependencies,
#       depending on the selected C library. Those deps are added later

$(STAMP_DIR)/ct-ng-toolchain-built: $(CTNG_DIR)/.config
	$(Q)$(call MESSAGE,"Building the crosstool-NG toolchain")
	$(Q)$(call ctng,build.$(PARALLEL_JOBS))
	$(Q)printf "\n"
	$(Q)touch $@

#-----------------------------------------------------------------------------
# Configuring the toolchain

#--------------
# We push BR options down to CT-NG, munging the default configuration
# with sed expressions.
# - first one for non-path options
# - second for path options (because they have no prompt, they
#                            always get set to the default value)
# - third for C library .config (if it has one, eg. uClibc)
CTNG_FIX_BUILDROOT_CONFIG_SED       :=
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED :=
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED  :=

#--------------
# A few generic functions

# Munge a config file, given a sed expression
# $1: the .config file to munge
# $2: the sed expression to apply
define ctng-fix-dot-config
	$(Q)sed -r -e '$(2)' $(1) >$(1).sed
	$(Q)cmp $(1) $(1).sed >/dev/null 2>&1 && rm -f $(1).sed || mv -f $(1).sed $(1)
endef

# This function checks the .config did actually change
# If not changed, then current .config will be touched with reference to the
# stamp file. If the configuration did change, nothing is done.
# $1: the current .config to check
# $2: the time-stamped .config file
define ctng-check-config-changed
	$(Q)old_md5="$$( grep -v -E '^(#|$$)' $(2) 2>/dev/null  \
	                 |md5sum                                \
	                 |cut -d ' ' -f 1                       \
	               )";                                      \
	    new_md5="$$( grep -v -E '^(#|$$)' $(1) 2>/dev/null  \
	                 |md5sum                                \
	                 |cut -d ' ' -f 1                       \
	               )";                                      \
	    if [ $${old_md5} = $${new_md5} -a -f $(2) ]; then   \
	        touch -r $(2) $(1);                             \
	    fi
endef

#--------------
# Massage BR2_ARCH so that it matches CT-NG's ARCH
#
# Note: a lot of the following tricks would become unneeded if one day
# buildroot and crosstool-NG had matching options, especially for the
# target description: arch name, bitness, endianness...
#
# Note-2: missing conformity check between BR's .config and libc features.
# Use check_uclibc or check_glibc.

# Defaults:
CTNG_ARCH   := $(CTNG_BR2_ARCH)
CTNG_ENDIAN :=
CTNG_BIT    :=
# Architecture overides, only overide pertinent vars:
ifeq      ($(BR2_arm),y)
CTNG_ARCH   := arm
CTNG_ENDIAN := LE
else ifeq ($(BR2_armeb),y)
CTNG_ARCH   := arm
CTNG_ENDIAN := BE
else ifeq ($(BR2_i386),y)
CTNG_ARCH   := x86
CTNG_BIT    := 32
else ifeq ($(BR2_mips),y)
CTNG_ARCH   := mips
CTNG_ENDIAN := BE
else ifeq ($(BR2_mipsel),y)
CTNG_ARCH   := mips
CTNG_ENDIAN := LE
else ifeq ($(BR2_powerpc),y)
CTNG_ARCH   := powerpc
CTNG_BIT    := 32
else ifeq ($(BR2_x86_64),y)
CTNG_ARCH   := x86
CTNG_BIT    := 64
# Add other architecture overides below:
#  - keep alphabetic order
#  - duplicate next 4 lines, and uncomment
#       else ifeq ($(BR2_<arch_name_here>),y)
#       CTNG_ARCH   :=
#       CTNG_ENDIAN :=
#       CTNG_BIT    :=
#  - remove unneeded vars
#  - add BR arch-name on ifeq line
#  - fill-in required CTNG_* vars
endif

#--------------
# Massage BR options into CTNG .config file
# CT_ARCH                   : handled by the backend mechanism
# CT_ARCH_[BL]E             : endianness
# CT_ARCH_(32|64)           : bitness
# CT_PREFIX_DIR             : install into BR's toolchain dir
# CT_INSTALL_DIR_RO         : do *not* chmod a-w the toolchain dir
# CT_LOCAL_TARBALLS_DIR     : share downloads with BR
# CT_SYSROOT_DIR_PREFIX     : no prefix needed, really
# CT_TARGET_VENDOR          : try to set a unique vendor string, to avoid clashing with BR's vendor string
# CT_TARGET_ALIAS           : set the target tuple alias to GNU_TARGET_NAME so that packages' ./configure find the compiler
# CT_DEBUG_gdb              : deselect gdb+gdbserver if buildroot builds its own
# CT_CC_LANG_CXX            : required if we copy libstdc++.so, and build C++
# CT_LIBC_UCLIBC_CONFIG_FILE: uClibc config file, if needed
#
# Lots of other awfull sed manipulations go here, to override CT-NG's .config
# with BR2 config options.
# Known missing: arch options, uClibc/eglibc config...
#
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_INSTALL_DIR_RO)=y:\# \1 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_ARCH_[BL]E).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_ARCH_$(CTNG_ENDIAN)) is not set:\1=y:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_ARCH_(32|64)).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_ARCH_$(CTNG_BIT)) is not set:\1=y:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_TARGET_VENDOR)=.*:\1="buildroot":;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_TARGET_ALIAS)=.*:\1="$(ARCH)-linux":;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_TOOLCHAIN_PKGVERSION)="(.*)":\1="buildroot $(BR2_VERSION_FULL)":;
ifneq ($(call qstrip,$(BR2_USE_MMU)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_ARCH_USE_MMU) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_ARCH_USE_MMU)=y:\# \1 is not set:;
endif
ifneq ($(call qstrip,$(BR2_PACKAGE_GDB_SERVER))$(call qstrip,$(BR2_PACKAGE_GDB_HOST)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_DEBUG_gdb)=.*:\# \1 is not set:;
endif
ifeq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_CXX)),y)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_CC_LANG_CXX) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_CC_LANG_CXX)=.*:\# \1 is not set:;
endif

# Shoe-horn CPU variant now
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ARCH)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_ARCH_ARCH)=.*:\1=$(BR2_GCC_TARGET_ARCH):;
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_TUNE)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_ARCH_TUNE)=.*:\1=$(BR2_GCC_TARGET_TUNE):;
endif

# And floating point now
ifeq ($(call qstrip,$(BR2_SOFT_FLOAT)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_ARCH_FLOAT_HW) is not set:\1=y:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_ARCH_FLOAT_SW)=y:\# \1 is not set:;
else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_ARCH_FLOAT_HW)=y:\# \1 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_ARCH_FLOAT_SW) is not set:\1=y:;
endif

# Thread implementation selection
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_NONE).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_LINUXTHREADS).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_NPTL).*:\# \2 is not set:;
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_THREADS_PTHREADS))$(call qstrip,$(BR2_TOOLCHAIN_CTNG_THREADS_PTHREADS_OLD)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_LINUXTHREADS).*:\2=y:;
 ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc)),)
  ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_THREADS_PTHREADS_OLD)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_LIBC_UCLIBC_LNXTHRD_NEW).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_LIBC_UCLIBC_LNXTHRD_OLD).*:\2=y:;
  else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_LIBC_UCLIBC_LNXTHRD_OLD).*:\# \2 is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_LIBC_UCLIBC_LNXTHRD_NEW).*:\2=y:;
  endif
 endif
else ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_THREADS_NPTL)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_NPTL).*:\2=y:;
else ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_THREADS_NONE)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(|\# )(CT_THREADS_NONE).*:\2=y:;
endif

#--------------
# And the specials for paths
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED += s:^(CT_PREFIX_DIR)=.*:\1="$(HOST_DIR)/usr":;
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED += s:^(CT_LOCAL_TARBALLS_DIR)=.*:\1="$(DL_DIR)":;
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED += s:^(CT_SYSROOT_NAME)=.*:\1="sysroot":;
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED += s:^(CT_SYSROOT_DIR_PREFIX)=.*:\1="":;

#--------------
# uClibc specific options
ifeq ($(BR2_TOOLCHAIN_CTNG_uClibc),y)

# Handle the locales option
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc_LOCALE)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_LIBC_UCLIBC_LOCALES) is not set:\1=y\n\# CT_LIBC_UCLIBC_LOCALES_PREGEN_DATA is not set:;
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_LIBC_UCLIBC_LOCALES_PREGEN_DATA)=.*:\# \1 is not set:;
else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_LIBC_UCLIBC_LOCALES)=.*:\# \1 is not set:;
endif

# Handle the wide-char option
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc_WCHAR)),)
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_LIBC_UCLIBC_WCHAR) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_LIBC_UCLIBC_WCHAR)=.*:\# \1 is not set:;
endif

# Handle the LFS option
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc_LARGEFILE)),)
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^\# (UCLIBC_HAS_LFS) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^(UCLIBC_HAS_LFS)=.*:\# \1 is not set:;
endif

# Handle the IPv6 option
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc_INET_IPV6)),)
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^\# (UCLIBC_HAS_IPV6) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^(UCLIBC_HAS_IPV6)=.*:\# \1 is not set:;
endif

# Handle the RPC option
ifneq ($(call qstrip,$(BR2_TOOLCHAIN_CTNG_uClibc_INET_RPC)),)
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^\# (UCLIBC_HAS_RPC) is not set:\1=y\nUCLIBC_HAS_FULL_RPC=y\nUCLIBC_HAS_REENTRANT_RPC=y:;
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^\# (UCLIBC_HAS_FULL_RPC) is not set:\1=y:;
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^\# (UCLIBC_HAS_REENTRANT_RPC) is not set:\1=y:;
else
CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED += s:^(UCLIBC_HAS_RPC)=.*:\# \1 is not set:;
endif

# Instruct CT-NG's .config where to find the uClibc's .config
CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED += s:^(CT_LIBC_UCLIBC_CONFIG_FILE)=.*:\1="$(CTNG_DIR)/libc.config":;

# And add this to the toolchain build dependency
$(STAMP_DIR)/ct-ng-toolchain-built: $(CTNG_DIR)/libc.config

# And here is how we get this uClibc's .config
$(CTNG_DIR)/libc.config: $(CTNG_UCLIBC_CONFIG_FILE) $(BUILDROOT_CONFIG)
	-$(Q)cp -a $@ $@.timestamp
	$(Q)cp -f $< $@
	$(call ctng-fix-dot-config,$@,$(CTNG_FIX_BUILDROOT_CONFIG_LIBC_SED))
	$(call ctng-check-config-changed,$@,$@.timestamp)
	$(Q)rm -f $@.timestamp

endif # LIBC is uClibc

#--------------
# glibc/eglibc specific options
ifeq ($(BR2_TOOLCHAIN_CTNG_glibc)$(BR2_TOOLCHAIN_CTNG_eglibc),y)

# Force unwind support
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^\# (CT_LIBC_GLIBC_FORCE_UNWIND) is not set:\1=y:;

# Force non-fortified build
CTNG_FIX_BUILDROOT_CONFIG_SED += s:^(CT_LIBC_ENABLE_FORTIFIED_BUILD)=y:\# \1 is not set:;

endif # LIBC is glibc or eglibc

#--------------
# Small functions to shoe-horn the above into crosstool-NG's .config

# Function to update the .config
# We first munge the .config to shoe-horn defaults, then we push that unto
# crosstool-NG's oldconfig process, to sort out wizy-wazy deps, and then we
# shoe-horn paths again, as they get ripped-out by oldconfig (is that a bug
# or a feature of kconfig?)
# $1: the .config file to munge
define ctng-oldconfig
	$(call ctng-fix-dot-config,$(1),$(CTNG_FIX_BUILDROOT_CONFIG_SED))
	$(Q)yes ''                                             |\
	$(call ctng,CT_IS_A_BACKEND=y                           \
	            CT_BACKEND_ARCH=$(CTNG_ARCH)                \
	            CT_BACKEND_KERNEL=linux                     \
	            CT_BACKEND_LIBC=$(BR2_TOOLCHAIN_CTNG_LIBC)  \
	            oldconfig                                   )
	$(call ctng-fix-dot-config,$(1),$(CTNG_FIX_BUILDROOT_CONFIG_PATHS_SED))
endef

# We need the host crosstool-NG before we can even begin working
# on the toolchain. Using order-only dependency, as we do not want
# to rebuild the toolchain for every run...
$(CTNG_DIR)/.config: | host-crosstool-ng

# Default configuration
# Only copy the original .config file if we don't have one already.
# Check that given config file matches selected C library.
# We need to call oldconfig twice in a row to ensure the options
# are correctly set ( eg. if an option is new, then the initial sed
# can't do anything about it ) Ideally, this should go in oldconfig
# itself, but it's much easier to handle here.
$(CTNG_DIR)/.config:
	$(Q)if [ ! -f $@ ]; then                                                        \
	        mkdir -p "$(CTNG_DIR)";                                                 \
	        libc="$$(awk -F '"' '$$1=="CT_LIBC=" { print $$2; }'                    \
	                        "$(CTNG_CONFIG_FILE)"                                   \
	                )";                                                             \
	        if [ "$${libc}" != "$(BR2_TOOLCHAIN_CTNG_LIBC)" ]; then                 \
	            echo "* Inconsistency in crosstool-NG config file '$(CTNG_CONFIG_FILE)'"; \
	            echo "* - buildroot configured for '$(BR2_TOOLCHAIN_CTNG_LIBC)'";   \
	            echo "* - given config file for '$${libc}'";                        \
	            exit 1;                                                             \
	        fi;                                                                     \
	        cp -f $(CTNG_CONFIG_FILE) $@;                                                            \
	    fi
	$(call ctng-oldconfig,$@)
	$(call ctng-oldconfig,$@)

# Manual configuration
ctng-menuconfig: $(CTNG_DIR)/.config
	$(Q)cp -a $< $<.timestamp
	$(Q)$(call ctng,CT_IS_A_BACKEND=y                           \
	                CT_BACKEND_ARCH=$(CTNG_ARCH)                \
	                CT_BACKEND_KERNEL=linux                     \
	                CT_BACKEND_LIBC=$(BR2_TOOLCHAIN_CTNG_LIBC)  \
	                menuconfig                                  )
	$(call ctng-oldconfig,$<)
	$(call ctng-check-config-changed,$<,$<.timestamp)
	$(Q)rm -f $<.timestamp
