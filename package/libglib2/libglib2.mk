################################################################################
#
# libglib2
#
################################################################################

LIBGLIB2_VERSION_MAJOR = 2.36
LIBGLIB2_VERSION_MINOR = 3
LIBGLIB2_VERSION = $(LIBGLIB2_VERSION_MAJOR).$(LIBGLIB2_VERSION_MINOR)
LIBGLIB2_SOURCE = glib-$(LIBGLIB2_VERSION).tar.xz
LIBGLIB2_SITE = http://ftp.gnome.org/pub/gnome/sources/glib/$(LIBGLIB2_VERSION_MAJOR)
LIBGLIB2_LICENSE = LGPLv2+
LIBGLIB2_LICENSE_FILES = COPYING

LIBGLIB2_AUTORECONF = YES
HOST_LIBGLIB2_AUTORECONF = YES
LIBGLIB2_INSTALL_STAGING = YES
LIBGLIB2_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

LIBGLIB2_CONF_ENV = \
		ac_cv_func_posix_getpwuid_r=yes glib_cv_stack_grows=no \
		glib_cv_uscore=no ac_cv_func_strtod=yes \
		ac_fsusage_space=yes fu_cv_sys_stat_statfs2_bsize=yes \
		ac_cv_func_closedir_void=no ac_cv_func_getloadavg=no \
		ac_cv_lib_util_getloadavg=no ac_cv_lib_getloadavg_getloadavg=no \
		ac_cv_func_getgroups=yes ac_cv_func_getgroups_works=yes \
		ac_cv_func_chown_works=yes ac_cv_have_decl_euidaccess=no \
		ac_cv_func_euidaccess=no ac_cv_have_decl_strnlen=yes \
		ac_cv_func_strnlen_working=yes ac_cv_func_lstat_dereferences_slashed_symlink=yes \
		ac_cv_func_lstat_empty_string_bug=no ac_cv_func_stat_empty_string_bug=no \
		vb_cv_func_rename_trailing_slash_bug=no ac_cv_have_decl_nanosleep=yes \
		jm_cv_func_nanosleep_works=yes gl_cv_func_working_utimes=yes \
		ac_cv_func_utime_null=yes ac_cv_have_decl_strerror_r=yes \
		ac_cv_func_strerror_r_char_p=no jm_cv_func_svid_putenv=yes \
		ac_cv_func_getcwd_null=yes ac_cv_func_getdelim=yes \
		ac_cv_func_mkstemp=yes utils_cv_func_mkstemp_limitations=no \
		utils_cv_func_mkdir_trailing_slash_bug=no \
		jm_cv_func_gettimeofday_clobber=no \
		gl_cv_func_working_readdir=yes jm_ac_cv_func_link_follows_symlink=no \
		utils_cv_localtime_cache=no ac_cv_struct_st_mtim_nsec=no \
		gl_cv_func_tzset_clobber=no gl_cv_func_getcwd_null=yes \
		gl_cv_func_getcwd_path_max=yes ac_cv_func_fnmatch_gnu=yes \
		am_getline_needs_run_time_check=no am_cv_func_working_getline=yes \
		gl_cv_func_mkdir_trailing_slash_bug=no gl_cv_func_mkstemp_limitations=no \
		ac_cv_func_working_mktime=yes jm_cv_func_working_re_compile_pattern=yes \
		ac_use_included_regex=no gl_cv_c_restrict=no \
		ac_cv_path_GLIB_GENMARSHAL=$(HOST_DIR)/usr/bin/glib-genmarshal ac_cv_prog_F77=no \
		ac_cv_func_posix_getgrgid_r=no glib_cv_long_long_format=ll \
		ac_cv_func_printf_unix98=yes ac_cv_func_vsnprintf_c99=yes \
		ac_cv_func_newlocale=no ac_cv_func_uselocale=no \
		ac_cv_func_strtod_l=no ac_cv_func_strtoll_l=no ac_cv_func_strtoull_l=no \
		gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no)

# old uClibc versions don't provide qsort_r
ifeq ($(BR2_UCLIBC_VERSION_0_9_32)$(BR2_TOOLCHAIN_CTNG_uClibc)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEEL_V2)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEBE_V2),y)
LIBGLIB2_CONF_ENV += glib_cv_have_qsort_r=no
else
LIBGLIB2_CONF_ENV += glib_cv_have_qsort_r=yes
endif

# old toolchains don't have working inotify support
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEEL_V2)$(BR2_TOOLCHAIN_EXTERNAL_XILINX_MICROBLAZEBE_V2),y)
LIBGLIB2_CONF_ENV += ac_cv_header_sys_inotify_h=no
endif

HOST_LIBGLIB2_CONF_OPT = \
		--disable-gtk-doc \
		--enable-debug=no \
		--disable-dtrace \
		--disable-systemtap \
		--disable-gcov \
		--disable-modular-tests

LIBGLIB2_CONF_OPT += --disable-modular-tests
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
	LIBGLIB2_CONF_OPT += --with-threads=none --disable-threads
endif

LIBGLIB2_DEPENDENCIES = host-pkgconf host-libglib2 libffi zlib $(if $(BR2_NEEDS_GETTEXT),gettext) host-gettext

HOST_LIBGLIB2_DEPENDENCIES = host-pkgconf host-libffi host-zlib host-gettext

ifneq ($(BR2_ENABLE_LOCALE),y)
LIBGLIB2_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBGLIB2_CONF_OPT += --with-libiconv=gnu
LIBGLIB2_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
LIBGLIB2_CONF_OPT += --with-pcre=system
LIBGLIB2_DEPENDENCIES += pcre
else
LIBGLIB2_CONF_OPT += --with-pcre=internal
endif

define LIBGLIB2_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/glib-2.0
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gettext
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/glib-2.0
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
endef

LIBGLIB2_POST_INSTALL_TARGET_HOOKS += LIBGLIB2_REMOVE_DEV_FILES

define LIBGLIB2_REMOVE_GDB_FILES
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gdb
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/glib-2.0
endef

ifneq ($(BR2_PACKAGE_GDB),y)
LIBGLIB2_POST_INSTALL_TARGET_HOOKS += LIBGLIB2_REMOVE_GDB_FILES
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

LIBGLIB2_HOST_BINARY = $(HOST_DIR)/usr/bin/glib-genmarshal
