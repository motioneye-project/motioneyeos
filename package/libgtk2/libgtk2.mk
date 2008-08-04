#############################################################
#
# libgtk2.0
#
#############################################################
LIBGTK2_VERSION = 2.12.6
LIBGTK2_SOURCE = gtk+-$(LIBGTK2_VERSION).tar.bz2
LIBGTK2_SITE = ftp://ftp.gtk.org/pub/gtk/2.12
LIBGTK2_AUTORECONF = NO
LIBGTK2_INSTALL_STAGING = YES
LIBGTK2_INSTALL_TARGET = YES
LIBGTK2_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) install
LIBGTK2_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

LIBGTK2_CONF_ENV = ac_cv_func_posix_getpwuid_r=yes glib_cv_stack_grows=no \
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
		ac_cv_func_memcmp_working=yes \
		ac_cv_have_decl_malloc=yes \
		gl_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_calloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes \
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
		ac_use_included_regex=no gl_cv_c_restrict=no \
		ac_cv_path_GLIB_GENMARSHAL=$(HOST_GLIB)/bin/glib-genmarshal \
		ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_GLIB)/bin/gtk-update-icon-cache \
		ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_GLIB)/bin/gdk-pixbuf-csource \
		ac_cv_prog_F77=no \
		ac_cv_prog_CXX=no \
		ac_cv_path_CUPS_CONFIG=no

LIBGTK2_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/usr/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		--enable-static \
		--disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug \
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \
		PKG_CONFIG="$(STAGING_DIR)/usr/bin/pkg-config" \
		$(LIBGTK2_CONF_OPT_X)  \
		$(LIBGTK2_CONF_OPT_DFB)


ifeq ($(BR2_PACKAGE_DIRECTFB),y)
	LIBGTK2_CONF_OPT += --with-gdktarget=directfb
	LIBGTK2_DEPENDENCIES_EXTRA = directfb
endif

ifneq ($(BR2_PACKAGE_XSERVER_none),y)
	LIBGTK2_CONF_OPT += \
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--with-gdktarget=x11
	LIBGTK2_DEPENDENCIES_EXTRA = xlib_libXcomposite $(XSERVER)
else
	LIBGTK2_CONF_OPT += --without-x
endif

LIBGTK2_DEPENDENCIES = uclibc pkgconfig png jpeg tiff $(LIBGTK2_DEPENDENCIES_EXTRA) libglib2 cups cairo pango atk

$(eval $(call AUTOTARGETS,package,libgtk2))
