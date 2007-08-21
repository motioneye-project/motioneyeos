#############################################################
#
# cairo
#
#############################################################
CAIRO_VERSION:=1.2.6
CAIRO_SOURCE:=cairo-$(CAIRO_VERSION).tar.gz
CAIRO_SITE:=http://cairographics.org/releases
CAIRO_CAT:=$(ZCAT)
CAIRO_DIR:=$(BUILD_DIR)/cairo-$(CAIRO_VERSION)
CAIRO_BINARY:=libcairo.a

$(DL_DIR)/$(CAIRO_SOURCE):
	 $(WGET) -P $(DL_DIR) $(CAIRO_SITE)/$(CAIRO_SOURCE)

cairo-source: $(DL_DIR)/$(CAIRO_SOURCE)

$(CAIRO_DIR)/.unpacked: $(DL_DIR)/$(CAIRO_SOURCE)
	$(CAIRO_CAT) $(DL_DIR)/$(CAIRO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(CAIRO_DIR) package/cairo/ \*.patch*
	$(CONFIG_UPDATE) $(CAIRO_DIR)
	touch $(CAIRO_DIR)/.unpacked

$(CAIRO_DIR)/.configured: $(CAIRO_DIR)/.unpacked
	(cd $(CAIRO_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
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
		ac_use_included_regex=no \
		gl_cv_c_restrict=no \
		ac_cv_path_GLIB_GENMARSHAL=/usr/bin/glib-genmarshal \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/usr/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		--enable-static \
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/include \
		--x-libraries=$(STAGING_DIR)/lib \
		--enable-ps=yes \
		--enable-pdf=yes \
		--enable-svg=no \
		--enable-png=yes \
		--enable-freetype=yes \
		--enable-xlib=yes \
		--enable-xlib-xrender=yes \
	);
	touch $(CAIRO_DIR)/.configured

$(CAIRO_DIR)/src/.libs/$(CAIRO_BINARY): $(CAIRO_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(CAIRO_DIR)
	touch -c $(CAIRO_DIR)/src/.libs/$(CAIRO_BINARY)

$(STAGING_DIR)/lib/$(CAIRO_BINARY): $(CAIRO_DIR)/src/.libs/$(CAIRO_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(CAIRO_DIR) install;
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libcairo.la
	touch -c $(STAGING_DIR)/lib/$(CAIRO_BINARY)

$(TARGET_DIR)/lib/libcairo.so.2.9.3: $(STAGING_DIR)/lib/$(CAIRO_BINARY)
	cp -a $(STAGING_DIR)/lib/libcairo.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libcairo.so.2* $(TARGET_DIR)/lib/
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libcairo.so.2.*
	touch -c $(TARGET_DIR)/lib/libcairo.so.2.9.3

cairo: uclibc gettext libintl pkgconfig libglib2 $(XSERVER) $(TARGET_DIR)/lib/libcairo.so.2.9.3

cairo-clean:
	rm -f $(TARGET_DIR)/lib/$(CAIRO_BINARY)
	-$(MAKE) -C $(CAIRO_DIR) clean

cairo-dirclean:
	rm -rf $(CAIRO_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_CAIRO)),y)
TARGETS+=cairo
endif
