#############################################################
#
# libglib2
#
#############################################################
LIBGLIB2_VERSION:=2.12.9
LIBGLIB2_SOURCE:=glib-$(LIBGLIB2_VERSION).tar.bz2
LIBGLIB2_SITE:=http://ftp.gtk.org/pub/glib/2.12
LIBGLIB2_CAT:=$(BZCAT)
LIBGLIB2_DIR:=$(BUILD_DIR)/glib-$(LIBGLIB2_VERSION)
LIBGLIB2_BINARY:=libglib-2.0.a

$(DL_DIR)/$(LIBGLIB2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBGLIB2_SITE)/$(LIBGLIB2_SOURCE)

libglib2-source: $(DL_DIR)/$(LIBGLIB2_SOURCE)

$(LIBGLIB2_DIR)/.unpacked: $(DL_DIR)/$(LIBGLIB2_SOURCE)
	$(LIBGLIB2_CAT) $(DL_DIR)/$(LIBGLIB2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGLIB2_DIR) package/libglib2/ \*.patch*
	$(INSTALL) -m 0644 package/libglib2/glibconfig-sysdefs.h $(LIBGLIB2_DIR)/
	$(CONFIG_UPDATE) $(LIBGLIB2_DIR)
	touch $(LIBGLIB2_DIR)/.unpacked

$(LIBGLIB2_DIR)/.configured: $(LIBGLIB2_DIR)/.unpacked
	(cd $(LIBGLIB2_DIR); rm -rf config.cache; \
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
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--enable-shared \
		--enable-static \
		$(DISABLE_NLS) \
	)
	touch $(LIBGLIB2_DIR)/.configured

$(LIBGLIB2_DIR)/glib/.libs/$(LIBGLIB2_BINARY): $(LIBGLIB2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBGLIB2_DIR)
	touch -c $(LIBGLIB2_DIR)/glib/.libs/$(LIBGLIB2_BINARY)

$(STAGING_DIR)/lib/$(LIBGLIB2_BINARY): $(LIBGLIB2_DIR)/glib/.libs/$(LIBGLIB2_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(LIBGLIB2_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libglib-2.0.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgmodule-2.0.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgobject-2.0.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgthread-2.0.la

$(TARGET_DIR)/lib/libglib-2.0.so.0.1200.6: $(STAGING_DIR)/lib/$(LIBGLIB2_BINARY)
	cp -a $(STAGING_DIR)/lib/libglib-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libglib-2.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgmodule-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgmodule-2.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgobject-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgobject-2.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgthread-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgthread-2.0.so.0* $(TARGET_DIR)/lib/
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libglib-2.0.so.0.*
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgmodule-2.0.so.0.*
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgobject-2.0.so.0.*
	$(STRIP) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/libgthread-2.0.so.0.*
	touch -c $(TARGET_DIR)/lib/libglib-2.0.so.0.1200.6

libglib2: uclibc gettext libintl pkgconfig $(TARGET_DIR)/lib/libglib-2.0.so.0.1200.6

libglib2-clean:
	rm -f $(TARGET_DIR)/usr/lib/libglib-2.0*
	rm -f $(TARGET_DIR)/usr/lib/libgmodule-2.0*
	rm -f $(TARGET_DIR)/usr/lib/libgobject-2.0*
	rm -f $(TARGET_DIR)/usr/lib/libgthread-2.0*
	-$(MAKE) -C $(LIBGLIB2_DIR) clean

libglib2-dirclean:
	rm -rf $(LIBGLIB2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGLIB2)),y)
TARGETS+=libglib2
endif
