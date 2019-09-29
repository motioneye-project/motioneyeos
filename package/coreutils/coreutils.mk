################################################################################
#
# coreutils
#
################################################################################

COREUTILS_VERSION = 8.30
COREUTILS_SITE = $(BR2_GNU_MIRROR)/coreutils
COREUTILS_SOURCE = coreutils-$(COREUTILS_VERSION).tar.xz
COREUTILS_LICENSE = GPL-3.0+
COREUTILS_LICENSE_FILES = COPYING

# coreutils-01-fix-for-dummy-man-usage.patch triggers autoreconf on build
COREUTILS_AUTORECONF = YES
COREUTILS_GETTEXTIZE = YES

COREUTILS_CONF_OPTS = --disable-rpath --enable-single-binary=symlinks \
	$(if $(BR2_TOOLCHAIN_USES_MUSL),--with-included-regex)
COREUTILS_CONF_ENV = ac_cv_c_restrict=no \
	ac_cv_func_chown_works=yes \
	ac_cv_func_euidaccess=no \
	ac_cv_func_fstatat=yes \
	ac_cv_func_getdelim=yes \
	ac_cv_func_getgroups=yes \
	ac_cv_func_getgroups_works=yes \
	ac_cv_func_getloadavg=no \
	ac_cv_func_lstat_dereferences_slashed_symlink=yes \
	ac_cv_func_lstat_empty_string_bug=no \
	ac_cv_func_strerror_r_char_p=no \
	ac_cv_func_strnlen_working=yes \
	ac_cv_func_strtod=yes \
	ac_cv_func_working_mktime=yes \
	ac_cv_have_decl_strerror_r=yes \
	ac_cv_have_decl_strnlen=yes \
	ac_cv_lib_getloadavg_getloadavg=no \
	ac_cv_lib_util_getloadavg=no \
	ac_fsusage_space=yes \
	ac_use_included_regex=no \
	am_cv_func_working_getline=yes \
	fu_cv_sys_stat_statfs2_bsize=yes \
	gl_cv_func_getcwd_null=yes \
	gl_cv_func_getcwd_path_max=yes \
	gl_cv_func_gettimeofday_clobber=no \
	gl_cv_func_fstatat_zero_flag=no \
	gl_cv_func_link_follows_symlink=no \
	gl_cv_func_re_compile_pattern_working=yes \
	gl_cv_func_svid_putenv=yes \
	gl_cv_func_tzset_clobber=no \
	gl_cv_func_working_mkstemp=yes \
	gl_cv_func_working_utimes=yes \
	gl_getline_needs_run_time_check=no \
	gl_cv_have_proc_uptime=yes \
	utils_cv_localtime_cache=no \
	PERL=missing \
	MAKEINFO=true \
	INSTALL_PROGRAM=$(INSTALL)

COREUTILS_BIN_PROGS = cat chgrp chmod chown cp date dd df dir echo false \
	kill link ln ls mkdir mknod mktemp mv nice printenv pwd rm rmdir \
	vdir sleep stty sync touch true uname join

ifeq ($(BR2_PACKAGE_ACL),y)
COREUTILS_DEPENDENCIES += acl
else
COREUTILS_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
COREUTILS_DEPENDENCIES += attr
else
COREUTILS_CONF_OPTS += --disable-xattr
endif

COREUTILS_DEPENDENCIES += $(TARGET_NLS_DEPENDENCIES)

# It otherwise fails to link properly, not mandatory though
ifeq ($(BR2_PACKAGE_GETTEXT_PROVIDES_LIBINTL),y)
COREUTILS_CONF_OPTS += --with-libintl-prefix=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_GMP),y)
COREUTILS_DEPENDENCIES += gmp
else
COREUTILS_CONF_OPTS += --without-gmp
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
COREUTILS_DEPENDENCIES += libcap
else
COREUTILS_CONF_OPTS += --disable-libcap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
COREUTILS_CONF_OPTS += --with-openssl=yes
COREUTILS_DEPENDENCIES += openssl
endif

ifeq ($(BR2_ROOTFS_MERGED_USR),)
define COREUTILS_CLEANUP_BIN
	# some things go in /bin rather than /usr/bin
	$(foreach f,$(COREUTILS_BIN_PROGS), \
		rm -f $(TARGET_DIR)/usr/bin/$(f) && \
		ln -sf ../usr/bin/coreutils $(TARGET_DIR)/bin/$(f)
	)
endef
COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_CLEANUP_BIN
endif

ifeq ($(BR2_STATIC_LIBS),y)
COREUTILS_CONF_OPTS += --enable-no-install-program=stdbuf
endif

define COREUTILS_CLEANUP
	# link for archaic shells
	ln -fs coreutils $(TARGET_DIR)/usr/bin/[
	# gnu thinks chroot is in bin, debian thinks it's in sbin
	rm -f $(TARGET_DIR)/usr/bin/chroot
	ln -sf ../bin/coreutils $(TARGET_DIR)/usr/sbin/chroot
endef

COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_CLEANUP

$(eval $(autotools-package))
