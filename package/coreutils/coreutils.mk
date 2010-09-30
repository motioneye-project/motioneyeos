#############################################################
#
# coreutils
#
#############################################################
COREUTILS_VERSION = 7.4
COREUTILS_SOURCE = coreutils-$(COREUTILS_VERSION).tar.gz
COREUTILS_SITE = $(BR2_GNU_MIRROR)/coreutils

# If both coreutils and busybox are selected, make certain coreutils
# wins the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
COREUTILS_DEPENDENCIES = busybox
endif

COREUTILS_BIN_PROGS = cat chgrp chmod chown cp date dd df dir echo false hostname \
	ln ls mkdir mknod mv pwd rm rmdir vdir sleep stty sync touch true \
	uname join

COREUTILS_CONF_ENV = ac_cv_func_strtod=yes \
		ac_fsusage_space=yes \
		fu_cv_sys_stat_statfs2_bsize=yes \
		ac_cv_func_closedir_void=no \
		ac_cv_func_getloadavg=no \
		ac_cv_lib_util_getloadavg=no \
		ac_cv_lib_getloadavg_getloadavg=no \
		ac_cv_func_getgroups=yes \
		ac_cv_func_getgroups_works=yes \
		ac_cv_func_chown_works=yes \
		ac_cv_have_decl_euidaccess=no \
		ac_cv_func_euidaccess=no \
		ac_cv_have_decl_strnlen=yes \
		ac_cv_func_strnlen_working=yes \
		ac_cv_func_lstat_dereferences_slashed_symlink=yes \
		ac_cv_func_lstat_empty_string_bug=no \
		ac_cv_func_stat_empty_string_bug=no \
		gl_cv_func_rename_trailing_slash_bug=no \
		ac_cv_have_decl_nanosleep=yes \
		jm_cv_func_nanosleep_works=yes \
		gl_cv_func_working_utimes=yes \
		ac_cv_func_utime_null=yes \
		ac_cv_have_decl_strerror_r=yes \
		ac_cv_func_strerror_r_char_p=no \
		jm_cv_func_svid_putenv=yes \
		ac_cv_func_getcwd_null=yes \
		ac_cv_func_getdelim=yes \
		ac_cv_func_mkstemp=yes \
		utils_cv_func_mkstemp_limitations=no \
		utils_cv_func_mkdir_trailing_slash_bug=no \
		gl_cv_func_rename_dest_exists_bug=no \
		jm_cv_func_gettimeofday_clobber=no \
		am_cv_func_working_getline=yes \
		gl_cv_func_working_readdir=yes \
		jm_ac_cv_func_link_follows_symlink=no \
		utils_cv_localtime_cache=no \
		ac_cv_struct_st_mtim_nsec=no \
		gl_cv_func_tzset_clobber=no \
		gl_cv_func_getcwd_null=yes \
		gl_cv_func_getcwd_path_max=yes \
		ac_cv_func_fnmatch_gnu=yes \
		am_getline_needs_run_time_check=no \
		am_cv_func_working_getline=yes \
		gl_cv_func_mkdir_trailing_slash_bug=no \
		gl_cv_func_mkstemp_limitations=no \
		ac_cv_func_working_mktime=yes \
		jm_cv_func_working_re_compile_pattern=yes \
		ac_use_included_regex=no \
		gl_cv_c_restrict=no

COREUTILS_CONF_OPT = --disable-rpath \
		--disable-dependency-tracking

define COREUTILS_TOUCH_RENAME_M4
	# ensure rename.m4 file is older than configure / aclocal.m4 so
	# auto* isn't rerun
	touch -d '1979-01-01' $(@D)/m4/rename.m4
endef

COREUTILS_POST_PATCH_HOOKS += COREUTILS_TOUCH_RENAME_M4

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

$(eval $(call AUTOTARGETS,package,coreutils))
