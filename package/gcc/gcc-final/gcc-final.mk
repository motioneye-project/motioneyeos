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

ifneq ($(call qstrip, $(BR2_XTENSA_CORE_NAME)),)
HOST_GCC_FINAL_POST_EXTRACT_HOOKS += HOST_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_GCC_FINAL_POST_PATCH_HOOKS += HOST_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_GCC_FINAL_SUBDIR = build

HOST_GCC_FINAL_PRE_CONFIGURE_HOOKS += HOST_GCC_CONFIGURE_SYMLINK

define  HOST_GCC_FINAL_CONFIGURE_CMDS
	(cd $(HOST_GCC_FINAL_SRCDIR) && rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		$(HOST_GCC_FINAL_CONF_ENV) \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
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
	--with-build-time-tools=$(HOST_DIR)/usr/$(GNU_TARGET_NAME)/bin

HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*
# The kernel wants to use the -m4-nofpu option to make sure that it
# doesn't use floating point operations.
ifeq ($(BR2_sh4)$(BR2_sh4eb),y)
HOST_GCC_FINAL_CONF_OPTS += "--with-multilib-list=m4,m4-nofpu"
HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib/!m4*
endif
ifeq ($(BR2_sh4a)$(BR2_sh4aeb),y)
HOST_GCC_FINAL_CONF_OPTS += "--with-multilib-list=m4a,m4a-nofpu"
HOST_GCC_FINAL_GCC_LIB_DIR = $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib/!m4*
endif

# Disable shared libs like libstdc++ if we do static since it confuses linking
ifeq ($(BR2_STATIC_LIBS),y)
HOST_GCC_FINAL_CONF_OPTS += --disable-shared
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
	if [ ! -e $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-cc ]; then \
		ln -f $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-gcc \
			$(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-cc; \
	fi
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_CREATE_CC_SYMLINKS

HOST_GCC_FINAL_TOOLCHAIN_WRAPPER_ARGS += $(HOST_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)
HOST_GCC_FINAL_POST_BUILD_HOOKS += TOOLCHAIN_BUILD_WRAPPER
# Note: this must be done after CREATE_CC_SYMLINKS, otherwise the
# -cc symlink to the wrapper is not created.
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

# In gcc 4.7.x, the ARM EABIhf library loader path for (e)glibc was not
# correct, so we create a symbolic link to make things work
# properly. eglibc installs the library loader as ld-linux-armhf.so.3,
# but gcc creates binaries that reference ld-linux.so.3.
ifeq ($(BR2_arm)$(BR2_ARM_EABIHF)$(BR2_GCC_VERSION_4_7_X)$(BR2_TOOLCHAIN_USES_GLIBC),yyyy)
define HOST_GCC_FINAL_LD_LINUX_LINK
	ln -sf ld-linux-armhf.so.3 $(TARGET_DIR)/lib/ld-linux.so.3
	ln -sf ld-linux-armhf.so.3 $(STAGING_DIR)/lib/ld-linux.so.3
endef
HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_LD_LINUX_LINK
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

ifeq ($(BR2_xtensa),y)
HOST_GCC_FINAL_CONF_OPTS += --enable-cxx-flags="$(TARGET_ABI)"
endif

$(eval $(host-autotools-package))
