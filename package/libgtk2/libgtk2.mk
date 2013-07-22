################################################################################
#
# libgtk2
#
################################################################################

LIBGTK2_VERSION_MAJOR = 2.24
LIBGTK2_VERSION_MINOR = 18
LIBGTK2_VERSION = $(LIBGTK2_VERSION_MAJOR).$(LIBGTK2_VERSION_MINOR)

LIBGTK2_SOURCE = gtk+-$(LIBGTK2_VERSION).tar.xz
LIBGTK2_SITE = http://ftp.gnome.org/pub/gnome/sources/gtk+/$(LIBGTK2_VERSION_MAJOR)
LIBGTK2_INSTALL_STAGING = YES
LIBGTK2_INSTALL_TARGET = YES

LIBGTK2_AUTORECONF = YES

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
		ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_DIR)/usr/bin/gtk-update-icon-cache \
		ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_DIR)/usr/bin/gdk-pixbuf-csource \
		ac_cv_prog_F77=no \
		ac_cv_path_CUPS_CONFIG=no

LIBGTK2_CONF_OPT = --disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug

LIBGTK2_DEPENDENCIES = host-pkgconf host-libgtk2 libglib2 cairo pango atk gdk-pixbuf

# Xorg dependencies
LIBGTK2_CONF_OPT += \
	--with-x \
	--x-includes=$(STAGING_DIR)/usr/include/X11 \
	--x-libraries=$(STAGING_DIR)/usr/lib \
	--with-gdktarget=x11
LIBGTK2_DEPENDENCIES += xlib_libXcomposite fontconfig xlib_libX11 \
	xlib_libXext xlib_libXrender

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
	LIBGTK2_CONF_OPT += --enable-xinerama
	LIBGTK2_DEPENDENCIES += xlib_libXinerama
else
	LIBGTK2_CONF_OPT += --disable-xinerama
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
	LIBGTK2_CONF_OPT += --with-xinput=yes
	LIBGTK2_DEPENDENCIES += xlib_libXi
else
	LIBGTK2_CONF_OPT += --with-xinput=no
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
	LIBGTK2_DEPENDENCIES += xlib_libXrandr
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
	LIBGTK2_DEPENDENCIES += xlib_libXcursor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
	LIBGTK2_DEPENDENCIES += xlib_libXfixes
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
	LIBGTK2_DEPENDENCIES += xlib_libXcomposite
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
	LIBGTK2_DEPENDENCIES += xlib_libXdamage
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
LIBGTK2_DEPENDENCIES += libpng
else
LIBGTK2_CONF_OPT += --without-libpng
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
LIBGTK2_DEPENDENCIES += jpeg
else
LIBGTK2_CONF_OPT += --without-libjpeg
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
LIBGTK2_DEPENDENCIES += tiff
else
LIBGTK2_CONF_OPT += --without-libtiff
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
LIBGTK2_DEPENDENCIES += cups
else
LIBGTK2_CONF_OPT += --disable-cups
endif

ifeq ($(BR2_PACKAGE_LIBGTK2_DEMO),)
define LIBGTK2_POST_INSTALL_TWEAKS
	rm -rf $(TARGET_DIR)/usr/share/gtk-2.0/demo $(TARGET_DIR)/usr/bin/gtk-demo
endef

LIBGTK2_POST_INSTALL_TARGET_HOOKS += LIBGTK2_POST_INSTALL_TWEAKS
endif

# We do not build a full version of libgtk2 for the host, because that
# requires compiling Cairo, Pango, ATK and X.org for the
# host. Therefore, we patch it to remove dependencies, and we hack the
# build to only build gdk-pixbuf-from-source and
# gtk-update-icon-cache, which are the host tools needed to build Gtk
# for the target.

HOST_LIBGTK2_DEPENDENCIES = host-libglib2 host-libpng host-gdk-pixbuf
HOST_LIBGTK2_AUTORECONF = YES
HOST_LIBGTK2_CONF_OPT = \
		--disable-static \
		--disable-glibtest \
		--without-libtiff \
		--without-libjpeg \
		--with-gdktarget=none \
		--disable-cups \
		--disable-debug

define HOST_LIBGTK2_BUILD_CMDS
 $(HOST_MAKE_ENV) make -C $(@D)/gtk gtk-update-icon-cache
endef

define HOST_LIBGTK2_INSTALL_CMDS
 cp $(@D)/gtk/gtk-update-icon-cache $(HOST_DIR)/usr/bin
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
