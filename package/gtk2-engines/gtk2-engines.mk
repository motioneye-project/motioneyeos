################################################################################
#
# gtk2-engines
#
################################################################################

GTK2_ENGINES_VERSION_MAJOR = 2.20
GTK2_ENGINES_VERSION = $(GTK2_ENGINES_VERSION_MAJOR).2
GTK2_ENGINES_SOURCE = gtk-engines-$(GTK2_ENGINES_VERSION).tar.bz2
GTK2_ENGINES_SITE = http://ftp.gnome.org/pub/GNOME/sources/gtk-engines/$(GTK2_ENGINES_VERSION_MAJOR)
GTK2_ENGINES_DEPENDENCIES = libgtk2 host-intltool
GTK2_ENGINES_LICENSE = LGPLv2.1+
GTK2_ENGINES_LICENSE_FILES = COPYING

GTK2_ENGINES_CONF_ENV = \
		ac_cv_func_posix_getpwuid_r=yes \
		glib_cv_stack_grows=no \
		glib_cv_uscore=no \
		ac_cv_func_strtod=yes \
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
		vb_cv_func_rename_trailing_slash_bug=no \
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
		jm_cv_func_gettimeofday_clobber=no \
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
		gl_cv_c_restrict=no \
		ac_cv_path_CUPS_CONFIG=no

GTK2_ENGINES_CONF_OPT = \
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug \
		--enable-clearlooks \
		--disable-crux \
		--disable-hc \
		--disable-industrial \
		--disable-mist \
		--disable-redmond \
		--disable-smooth \
		--disable-glide \
		--disable-thinice \
		--enable-animation \
		--disable-development \
		--disable-paranoia \
		--disable-deprecated

$(eval $(autotools-package))
