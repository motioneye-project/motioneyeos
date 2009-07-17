#############################################################
#
# pango
#
#############################################################
PANGO_VERSION = 1.20.5
PANGO_SOURCE = pango-$(PANGO_VERSION).tar.bz2
PANGO_SITE = http://ftp.gnome.org/pub/GNOME/sources/pango/1.20
PANGO_AUTORECONF = YES
PANGO_INSTALL_STAGING = YES
PANGO_INSTALL_TARGET = YES

PANGO_CONF_ENV = ac_cv_func_posix_getpwuid_r=yes glib_cv_stack_grows=no \
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
		utils_cv_func_mkdir_trailing_slash_bug=no ac_cv_func_memcmp_working=yes \
		ac_cv_have_decl_malloc=yes gl_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_malloc_0_nonnull=yes ac_cv_func_calloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes jm_cv_func_gettimeofday_clobber=no \
		gl_cv_func_working_readdir=yes jm_ac_cv_func_link_follows_symlink=no \
		utils_cv_localtime_cache=no ac_cv_struct_st_mtim_nsec=no \
		gl_cv_func_tzset_clobber=no gl_cv_func_getcwd_null=yes \
		gl_cv_func_getcwd_path_max=yes ac_cv_func_fnmatch_gnu=yes \
		am_getline_needs_run_time_check=no am_cv_func_working_getline=yes \
		gl_cv_func_mkdir_trailing_slash_bug=no gl_cv_func_mkstemp_limitations=no \
		ac_cv_func_working_mktime=yes jm_cv_func_working_re_compile_pattern=yes \
		ac_use_included_regex=no gl_cv_c_restrict=no \
		ac_cv_path_FREETYPE_CONFIG=$(STAGING_DIR)/usr/bin/freetype-config

PANGO_CONF_OPT = --enable-shared --enable-static \
		--enable-explicit-deps=no --disable-debug

PANGO_DEPENDENCIES = uclibc gettext libintl host-pkgconfig libglib2 cairo

ifeq ($(BR2_PACKAGE_XORG7),y)
        PANGO_CONF_OPT += --with-x \
		--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib --disable-glibtest
	PANGO_DEPENDENCIES += xserver_xorg-server
else
        PANGO_CONF_OPT += --without-x
endif

$(eval $(call AUTOTARGETS,package,pango))

$(PANGO_HOOK_POST_INSTALL):
	mkdir -p $(TARGET_DIR)/etc/pango
	$(PANGO_HOST_BINARY) > $(TARGET_DIR)/etc/pango/pango.modules
	$(SED) 's~$(HOST_DIR)~~g' $(TARGET_DIR)/etc/pango/pango.modules
	touch $@

# pango for the host
PANGO_HOST_DIR:=$(BUILD_DIR)/pango-$(PANGO_VERSION)-host
PANGO_HOST_BINARY:=$(HOST_DIR)/usr/bin/pango-querymodules

$(DL_DIR)/$(PANGO_SOURCE):
	$(call DOWNLOAD,$(PANGO_SITE),$(PANGO_SOURCE))

$(STAMP_DIR)/host_pango_unpacked: $(DL_DIR)/$(PANGO_SOURCE)
	mkdir -p $(PANGO_HOST_DIR)
	$(INFLATE$(suffix $(PANGO_SOURCE))) $< | \
		$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $(PANGO_HOST_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(PANGO_HOST_DIR) package/pango/ \*.patch
	touch $@

$(STAMP_DIR)/host_pango_configured: $(STAMP_DIR)/host_pango_unpacked $(STAMP_DIR)/host_cairo_installed $(STAMP_DIR)/host_libglib2_installed $(STAMP_DIR)/host_autoconf_installed  $(STAMP_DIR)/host_automake_installed
	(cd $(PANGO_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		./configure \
		--prefix="$(HOST_DIR)/usr" \
		--sysconfdir="$(HOST_DIR)/etc" \
		--disable-static \
		$(if $(BR2_PACKAGE_XORG7),--with-x,--without-x) \
		--disable-debug \
	)
	touch $@

$(STAMP_DIR)/host_pango_compiled: $(STAMP_DIR)/host_pango_configured
	$(HOST_MAKE_ENV) PKG_CONFIG_PATH="$(HOST_DIR)/usr/lib/pkgconfig$(PKG_CONFIG_PATH)" $(MAKE) -C $(PANGO_HOST_DIR)
	touch $@

$(STAMP_DIR)/host_pango_installed: $(STAMP_DIR)/host_pango_compiled
	$(HOST_MAKE_ENV) $(MAKE) -C $(PANGO_HOST_DIR) install
	touch $@

host-pango: $(STAMP_DIR)/host_pango_installed

host-pango-source: pango-source

host-pango-clean:
	rm -f $(addprefix $(STAMP_DIR)/host_pango_,unpacked configured compiled installed)
	-$(MAKE) -C $(PANGO_HOST_DIR) uninstall
	-$(MAKE) -C $(PANGO_HOST_DIR) clean

host-pango-dirclean:
	rm -rf $(PANGO_HOST_DIR)
