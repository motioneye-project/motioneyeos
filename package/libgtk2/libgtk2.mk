#############################################################
#
# libgtk2.0
#
#############################################################
LIBGTK2_VERSION_MAJOR:=2.12
LIBGTK2_VERSION_MINOR:=12
LIBGTK2_VERSION = $(LIBGTK2_VERSION_MAJOR).$(LIBGTK2_VERSION_MINOR)

LIBGTK2_SOURCE = gtk+-$(LIBGTK2_VERSION).tar.bz2
LIBGTK2_SITE = ftp://ftp.gtk.org/pub/gtk/$(LIBGTK2_VERSION_MAJOR)
LIBGTK2_AUTORECONF = NO
LIBGTK2_INSTALL_STAGING = YES
LIBGTK2_INSTALL_TARGET = YES

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
		ac_cv_path_GTK_UPDATE_ICON_CACHE=$(HOST_DIR)/usr/bin/gtk-update-icon-cache \
		ac_cv_path_GDK_PIXBUF_CSOURCE=$(HOST_DIR)/usr/bin/gdk-pixbuf-csource \
		ac_cv_prog_F77=no \
		ac_cv_path_CUPS_CONFIG=no

LIBGTK2_CONF_OPT = --enable-shared \
		--enable-static \
		--disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug

LIBGTK2_DEPENDENCIES = host-pkgconfig host-libgtk2 libglib2 cairo pango atk

ifeq ($(BR2_PACKAGE_DIRECTFB),y)
	LIBGTK2_CONF_OPT += --with-gdktarget=directfb
	LIBGTK2_DEPENDENCIES += directfb
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
	LIBGTK2_CONF_OPT += \
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib \
		--with-gdktarget=x11
	LIBGTK2_DEPENDENCIES += xlib_libXcomposite xserver_xorg-server
else
	LIBGTK2_CONF_OPT += --without-x
endif

# Buildroot does not support JPEG2000 library
ifeq ($(LIBGTK2_VERSION_MAJOR),2.15)
LIBGTK2_CONF_OPT += --without-libjasper
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

$(eval $(call AUTOTARGETS,package,libgtk2))

$(LIBGTK2_HOOK_POST_INSTALL):
	$(INSTALL) -m 755 package/libgtk2/S26libgtk2 $(TARGET_DIR)/etc/init.d/
	rm -rf $(TARGET_DIR)/usr/share/gtk-2.0/demo $(TARGET_DIR)/usr/bin/gtk-demo
	touch $@

# libgtk2 for the host
LIBGTK2_HOST_DIR:=$(BUILD_DIR)/libgtk2-$(LIBGTK2_VERSION)-host

$(DL_DIR)/$(LIBGTK2_SOURCE):
	$(call DOWNLOAD,$(LIBGTK2_SITE),$(LIBGTK2_SOURCE))

$(STAMP_DIR)/host_libgtk2_unpacked: $(DL_DIR)/$(LIBGTK2_SOURCE)
	mkdir -p $(LIBGTK2_HOST_DIR)
	$(INFLATE$(suffix $(LIBGTK2_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(LIBGTK2_HOST_DIR) $(TAR_OPTIONS) -
	touch $@

$(STAMP_DIR)/host_libgtk2_configured: $(STAMP_DIR)/host_libgtk2_unpacked $(STAMP_DIR)/host_cairo_installed $(STAMP_DIR)/host_libglib2_installed $(STAMP_DIR)/host_pango_installed $(STAMP_DIR)/host_atk_installed
	(cd $(LIBGTK2_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
		--disable-glibtest \
		--without-libtiff \
		--without-libjpeg \
		--with-x \
		--with-gdktarget=x11 \
		--disable-cups \
		--disable-debug \
	)
	touch $@

$(STAMP_DIR)/host_libgtk2_compiled: $(STAMP_DIR)/host_libgtk2_configured
	$(HOST_MAKE_ENV) $(MAKE) -C $(LIBGTK2_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_libgtk2_installed: $(STAMP_DIR)/host_libgtk2_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(LIBGTK2_HOST_DIR) install
	touch $@

host-libgtk2: $(STAMP_DIR)/host_libgtk2_installed

host-libgtk2-source: libgtk2-source

host-libgtk2-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_libgtk2_,unpacked configured compiled installed)
	-$(MAKE) -C $(LIBGTK2_HOST_DIR) uninstall
	-$(MAKE) -C $(LIBGTK2_HOST_DIR) clean

host-libgtk2-dirclean:
	rm -rf $(LIBGTK2_HOST_DIR)
