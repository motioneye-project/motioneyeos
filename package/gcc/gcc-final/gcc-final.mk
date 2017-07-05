################################################################################
#
# gcc-final
#
################################################################################

GCC_FINAL_VERSION = $(GCC_VERSION)
GCC_FINAL_SITE = $(GCC_SITE)
GCC_FINAL_SOURCE = $(GCC_SOURCE)

HOST_GCC_FINAL_DEPENDENCIES = \
	$(HOST_GCC_COMMON_DEPENDENCIES) \
	$(BR_LIBC)

HOST_GCC_FINAL_EXCLUDES = $(HOST_GCC_EXCLUDES)
HOST_GCC_FINAL_POST_EXTRACT_HOOKS += HOST_GCC_FAKE_TESTSUITE

ifneq ($(ARCH_XTENSA_CORE_NAME),)
HOST_GCC_FINAL_POST_EXTRACT_HOOKS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_GCC_FINAL_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_FINAL_SUBDIR = build

HOST_GCC_FINAL_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

# We want to always build the static variants of all the gcc libraries,
# of which libstdc++, libgomp, libmudflap...
# To do so, we can not just pass --enable-static to override the generic
# --disable-static flag, otherwise gcc fails to build some of those
# libraries, see;
#   http://lists.busybox.net/pipermail/buildroot/2013-October/080412.html
#
# So we must completely override the generic commands and provide our own.
#
define  HOST_GCC_FINAL_CONFIGURE_CMDS
	(cd $(HOST_GCC_FINAL_SRCDIR) && rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(HOST_GCC_FINAL_CONF_ENV) \
		./configure \
		--prefix="$(HOST_DIR)" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--enable-static \
		$(QUIET) $(HOST_GCC_FINAL_CONF_OPTS) \
	)
endef

# Languages supported by the cross-compiler
GCC_FINAL_CROSS_LANGUAGES-y = c
GCC_FINAL_CROSS_LANGUAGES-$(BR2_INSTALL_LIBSTDCPP) += c++
GCC_FINAL_CROSS_LANGUAGES-$(BR2_TOOLCHAIN_BUILDROOT_FORTRAN) += fortran
GCC_FINAL_CROSS_LANGUAGES = $(subst $(space),$(comma),$(GCC_FINAL_CROSS_LANGUAGES-y))

HOST_GCC_FINAL_CONF_OPTS = \
	$(HOST_GCC_COMMON_CONF_OPTS) \
	--enable-languages=$(GCC_FINAL_CROSS_LANGUAGES) \
	--with-build-time-tools=$(HOST_DIR)/$(GNU_TARGET_NAME)/bin

HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/$(GNU_TARGET_NAME)/lib*
# The kernel wants to use the -m4-nofpu option to make sure that it
# doesn't use floating point operations.
ifeq ($(BR2_sh4)$(BR2_sh4eb),y)
HOST_GCC_FINAL_CONF_OPTS += "--with-multilib-list=m4,m4-nofpu"
HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/$(GNU_TARGET_NAME)/lib/!m4*
endif
ifeq ($(BR2_sh4a)$(BR2_sh4aeb),y)
HOST_GCC_FINAL_CONF_OPTS += "--with-multilib-list=m4a,m4a-nofpu"
HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/$(GNU_TARGET_NAME)/lib/!m4*
endif

ifeq ($(BR2_bfin),y)
HOST_GCC_FINAL_CONF_OPTS += --disable-symvers
endif

# Disable shared libs like libstdc++ if we do static since it confuses linking
# In that case also disable libcilkrts as there is no static version
ifeq ($(BR2_STATIC_LIBS),y)
HOST_GCC_FINAL_CONF_OPTS += --disable-shared --disable-libcilkrts
else
HOST_GCC_FINAL_CONF_OPTS += --enable-shared
endif

ifeq ($(BR2_GCC_ENABLE_OPENMP),y)
HOST_GCC_FINAL_CONF_OPTS += --enable-libgomp
else
HOST_GCC_FINAL_CONF_OPTS += --disable-libgomp
endif

# End with user-provided options, so that they can override previously
# defined options.
HOST_GCC_FINAL_CONF_OPTS += \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

HOST_GCC_FINAL_CONF_ENV = \
	$(HOST_GCC_COMMON_CONF_ENV)

HOST_GCC_FINAL_MAKE_OPTS += $(HOST_GCC_COMMON_MAKE_OPTS)

# Make sure we have 'cc'
define HOST_GCC_FINAL_CREATE_CC_SYMLINKS
	if [ ! -e $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-cc ]; then \
		ln -f $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-gcc \
			$(HOST_DIR)/bin/$(GNU_TARGET_NAME)-cc; \
	fi
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_CREATE_CC_SYMLINKS

HOST_GCC_FINAL_TOOLCHAIN_WRAPPER_ARGS += $(HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)
HOST_GCC_FINAL_POST_BUILD_HOOKS += TOOLCHAIN_WRAPPER_BUILD
HOST_GCC_FINAL_POST_INSTALL_HOOKS += TOOLCHAIN_WRAPPER_INSTALL
# Note: this must be done after CREATE_CC_SYMLINKS, otherwise the
# -cc symlink to the wrapper is not created.
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

# coldfire is not working without removing these object files from libgcc.a
ifeq ($(BR2_m68k_cf),y)
define HOST_GCC_FINAL_M68K_LIBGCC_FIXUP
	find $(STAGING_DIR) -name libgcc.a -print | \
		while read t; do $(GNU_TARGET_NAME)-ar dv "$t" _ctors.o; done
endef
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_M68K_LIBGCC_FIXUP
endif

# Cannot use the HOST_GCC_FINAL_USR_LIBS mechanism below, because we want
# libgcc_s to be installed in /lib and not /usr/lib.
define HOST_GCC_FINAL_INSTALL_LIBGCC
	-cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/libgcc_s* \
		$(STAGING_DIR)/lib/
	-cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/libgcc_s* \
		$(TARGET_DIR)/lib/
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_INSTALL_LIBGCC

define HOST_GCC_FINAL_INSTALL_LIBATOMIC
	-cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/libatomic* \
		$(STAGING_DIR)/lib/
	-cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/libatomic* \
		$(TARGET_DIR)/lib/
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_INSTALL_LIBATOMIC

# Handle the installation of libraries in /usr/lib
HOST_GCC_FINAL_USR_LIBS =

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
HOST_GCC_FINAL_USR_LIBS += libstdc++
endif

ifeq ($(BR2_TOOLCHAIN_BUILDROOT_FORTRAN),y)
HOST_GCC_FINAL_USR_LIBS += libgfortran
# fortran needs quadmath on x86 and x86_64
ifeq ($(BR2_TOOLCHAIN_HAS_LIBQUADMATH),y)
HOST_GCC_FINAL_USR_LIBS += libquadmath
endif
endif

ifeq ($(BR2_GCC_ENABLE_OPENMP),y)
HOST_GCC_FINAL_USR_LIBS += libgomp
endif

ifeq ($(BR2_GCC_ENABLE_LIBMUDFLAP),y)
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
HOST_GCC_FINAL_USR_LIBS += libmudflapth
else
HOST_GCC_FINAL_USR_LIBS += libmudflap
endif
endif

ifneq ($(HOST_GCC_FINAL_USR_LIBS),)
define HOST_GCC_FINAL_INSTALL_STATIC_LIBS
	for i in $(HOST_GCC_FINAL_USR_LIBS) ; do \
		cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/$${i}.a \
			$(STAGING_DIR)/usr/lib/ ; \
	done
endef

ifeq ($(BR2_STATIC_LIBS),)
define HOST_GCC_FINAL_INSTALL_SHARED_LIBS
	for i in $(HOST_GCC_FINAL_USR_LIBS) ; do \
		cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/$${i}.so* \
			$(STAGING_DIR)/usr/lib/ ; \
		cp -dpf $(HOST_GCC_FINAL_GCC_LIB_DIR)/$${i}.so* \
			$(TARGET_DIR)/usr/lib/ ; \
	done
endef
endif

define HOST_GCC_FINAL_INSTALL_USR_LIBS
	mkdir -p $(TARGET_DIR)/usr/lib
	$(HOST_GCC_FINAL_INSTALL_STATIC_LIBS)
	$(HOST_GCC_FINAL_INSTALL_SHARED_LIBS)
endef
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_INSTALL_USR_LIBS
endif

$(eval $(host-autotools-package))
