################################################################################
#
# coreutils
#
################################################################################

COREUTILS_VERSION = 8.21
COREUTILS_SITE = $(BR2_GNU_MIRROR)/coreutils
COREUTILS_SOURCE = coreutils-$(COREUTILS_VERSION).tar.xz
COREUTILS_LICENSE = GPLv3+
COREUTILS_LICENSE_FILES = COPYING

# patching gnulib .m4 file
COREUTILS_AUTORECONF = YES

# If both coreutils and busybox are selected, make certain coreutils
# wins the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
COREUTILS_DEPENDENCIES = busybox
endif

COREUTILS_BIN_PROGS = cat chgrp chmod chown cp date dd df dir echo false hostname \
	ln ls mkdir mknod mv pwd rm rmdir vdir sleep stty sync touch true \
	uname join

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
		utils_cv_localtime_cache=no \
		PERL=missing

COREUTILS_CONF_OPT = --disable-rpath \
		--disable-dependency-tracking \
		--enable-install-program=hostname

define COREUTILS_POST_INSTALL
	# some things go in root rather than usr
	for f in $(COREUTILS_BIN_PROGS); do \
		mv $(TARGET_DIR)/usr/bin/$$f $(TARGET_DIR)/bin/$$f; \
	done
	# link for archaic shells
	ln -fs test $(TARGET_DIR)/usr/bin/[
	# gnu thinks chroot is in bin, debian thinks it's in sbin
	mv $(TARGET_DIR)/usr/bin/chroot $(TARGET_DIR)/usr/sbin/chroot
endef

COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_POST_INSTALL

# If both coreutils and busybox are selected, the corresponding applets
# may need to be reinstated by the clean targets.

$(eval $(autotools-package))
