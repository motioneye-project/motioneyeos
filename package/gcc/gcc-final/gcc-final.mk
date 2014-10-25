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

HOST_GCC_FINAL_EXTRACT_CMDS = $(HOST_GCC_EXTRACT_CMDS)

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
GCC_FINAL_CROSS_LANGUAGES-$(BR2_INSTALL_FORTRAN) += fortran
GCC_FINAL_CROSS_LANGUAGES-$(BR2_INSTALL_OBJC)    += objc
GCC_FINAL_CROSS_LANGUAGES = $(subst $(space),$(comma),$(GCC_FINAL_CROSS_LANGUAGES-y))

HOST_GCC_FINAL_CONF_OPTS = \
	$(HOST_GCC_COMMON_CONF_OPTS) \
	--enable-languages=$(GCC_FINAL_CROSS_LANGUAGES) \
	$(DISABLE_LARGEFILE) \
	--with-build-time-tools=$(HOST_DIR)/usr/$(GNU_TARGET_NAME)/bin

# Disable shared libs like libstdc++ if we do static since it confuses linking
ifeq ($(BR2_PREFER_STATIC_LIB),y)
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

# Make sure we have 'cc'
define HOST_GCC_FINAL_CREATE_CC_SYMLINKS
	if [ ! -e $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-cc ]; then \
		ln -snf $(GNU_TARGET_NAME)-gcc \
			$(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-cc; \
	fi
	if [ ! -e $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/bin/cc ]; then \
		ln -snf gcc $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/bin/cc; \
	fi
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_CREATE_CC_SYMLINKS

# Create <arch>-linux-<tool> symlinks
define HOST_GCC_FINAL_CREATE_SIMPLE_SYMLINKS
	(cd $(HOST_DIR)/usr/bin; for i in $(GNU_TARGET_NAME)-*; do \
		ln -snf $$i $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
	done)
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_CREATE_SIMPLE_SYMLINKS

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
	-cp -dpf $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*/libgcc_s* \
		$(STAGING_DIR)/lib/
	-cp -dpf $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*/libgcc_s* \
		$(TARGET_DIR)/lib/
endef

HOST_GCC_FINAL_POST_INSTALL_HOOKS += HOST_GCC_FINAL_INSTALL_LIBGCC

# Handle the installation of libraries in /usr/lib
HOST_GCC_FINAL_USR_LIBS =

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
HOST_GCC_FINAL_USR_LIBS += libstdc++
endif

ifeq ($(BR2_GCC_ENABLE_OPENMP),y)
HOST_GCC_FINAL_USR_LIBS += libgomp
endif

ifeq ($(BR2_INSTALL_FORTRAN),y)
HOST_GCC_FINAL_USR_LIBS += libgfortran
endif

ifeq ($(BR2_INSTALL_OBJC),y)
HOST_GCC_FINAL_USR_LIBS += libobjc
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
		cp -dpf $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*/$${i}.a \
			$(STAGING_DIR)/usr/lib/ ; \
	done
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define HOST_GCC_FINAL_INSTALL_SHARED_LIBS
	for i in $(HOST_GCC_FINAL_USR_LIBS) ; do \
		cp -dpf $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*/$${i}.so* \
			$(STAGING_DIR)/usr/lib/ ; \
		cp -dpf $(HOST_DIR)/usr/$(GNU_TARGET_NAME)/lib*/$${i}.so* \
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
