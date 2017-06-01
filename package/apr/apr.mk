################################################################################
#
# apr
#
################################################################################

APR_VERSION = 1.5.2
APR_SOURCE = apr-$(APR_VERSION).tar.bz2
APR_SITE = http://archive.apache.org/dist/apr
APR_LICENSE = Apache-2.0
APR_LICENSE_FILES = LICENSE
APR_INSTALL_STAGING = YES
# We have a patch touching configure.in and Makefile.in,
# so we need to autoreconf:
APR_AUTORECONF = YES

APR_CONF_ENV = \
	CC_FOR_BUILD="$(HOSTCC)" \
	CFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
	ac_cv_file__dev_zero=yes \
	ac_cv_func_setpgrp_void=yes \
	apr_cv_process_shared_works=yes \
	apr_cv_mutex_robust_shared=no \
	apr_cv_tcp_nodelay_with_cork=yes \
	ac_cv_sizeof_struct_iovec=8 \
	ac_cv_sizeof_pid_t=4 \
	ac_cv_struct_rlimit=yes \
	ac_cv_o_nonblock_inherited=no \
	apr_cv_mutex_recursive=yes
APR_CONFIG_SCRIPTS = apr-1-config

# Doesn't even try to guess when cross compiling
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
APR_CONF_ENV += apr_cv_pthreads_lib="-lpthread"
endif

# Fix lfs detection when cross compiling
APR_CONF_ENV += apr_cv_use_lfs64=yes

# Use non-portable atomics when available: 8 bytes atomics are used on
# 64-bits architectures, 4 bytes atomics on 32-bits architectures. We
# have to override ap_cv_atomic_builtins because the test used to
# check for atomic builtins uses AC_TRY_RUN, which doesn't work when
# cross-compiling.
ifeq ($(BR2_ARCH_IS_64):$(BR2_TOOLCHAIN_HAS_SYNC_8),y:y)
APR_CONF_OPTS += --enable-nonportable-atomics
APR_CONF_ENV += ap_cv_atomic_builtins=yes
else ifeq ($(BR2_ARCH_IS_64):$(BR2_TOOLCHAIN_HAS_SYNC_4),:y)
APR_CONF_OPTS += --enable-nonportable-atomics
APR_CONF_ENV += ap_cv_atomic_builtins=yes
else
APR_CONF_OPTS += --disable-nonportable-atomics
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
APR_DEPENDENCIES += util-linux
endif

define APR_CLEANUP_UNNEEDED_FILES
	$(RM) -rf $(TARGET_DIR)/usr/build-1/
endef

APR_POST_INSTALL_TARGET_HOOKS += APR_CLEANUP_UNNEEDED_FILES

define APR_FIXUP_RULES_MK
	$(SED) 's%apr_builddir=%apr_builddir=$(STAGING_DIR)%' \
		$(STAGING_DIR)/usr/build-1/apr_rules.mk
	$(SED) 's%apr_builders=%apr_builders=$(STAGING_DIR)%' \
		$(STAGING_DIR)/usr/build-1/apr_rules.mk
	$(SED) 's%top_builddir=%top_builddir=$(STAGING_DIR)%' \
		$(STAGING_DIR)/usr/build-1/apr_rules.mk
endef

APR_POST_INSTALL_STAGING_HOOKS += APR_FIXUP_RULES_MK

$(eval $(autotools-package))
