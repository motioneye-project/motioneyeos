#############################################################
#
# atk
#
#############################################################
ATK_VERSION:=1.9.1
ATK_SOURCE:=atk-$(ATK_VERSION).tar.bz2
ATK_SITE:=ftp://ftp.gtk.org/pub/gtk/v2.10/dependencies
ATK_CAT:=$(BZCAT)
ATK_DIR:=$(BUILD_DIR)/atk-$(ATK_VERSION)
ATK_BINARY:=libatk-1.0.a

ifeq ($(BR2_ENDIAN),"BIG")
ATK_BE:=yes
else
ATK_BE:=no
endif

$(DL_DIR)/$(ATK_SOURCE):
	 $(WGET) -P $(DL_DIR) $(ATK_SITE)/$(ATK_SOURCE)

atk-source: $(DL_DIR)/$(ATK_SOURCE)

$(ATK_DIR)/.unpacked: $(DL_DIR)/$(ATK_SOURCE)
	$(ATK_CAT) $(DL_DIR)/$(ATK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ATK_DIR) package/atk/ \*.patch*
	$(CONFIG_UPDATE) $(ATK_DIR)
	touch $(ATK_DIR)/.unpacked

$(ATK_DIR)/.configured: $(ATK_DIR)/.unpacked
	(cd $(ATK_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		ac_cv_c_bigendian=$(ATK_BE) \
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
		--host=$(REAL_GNU_TARGET_NAME) \
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
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/X11R6/include \
		--x-libraries=$(STAGING_DIR)/usr/X11R6/lib \
		--disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug \
	);
	touch $(ATK_DIR)/.configured

$(ATK_DIR)/atk/.libs/$(ATK_BINARY): $(ATK_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ATK_DIR)
	touch -c $(ATK_DIR)/atk/.libs/$(ATK_BINARY)

$(STAGING_DIR)/lib/$(ATK_BINARY): $(ATK_DIR)/atk/.libs/$(ATK_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(ATK_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libatk-1.0.la
	touch -c $(STAGING_DIR)/lib/$(ATK_BINARY)

$(TARGET_DIR)/lib/libatk-1.0.so.0: $(STAGING_DIR)/lib/$(ATK_BINARY)
	cp -a $(STAGING_DIR)/lib/libatk-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libatk-1.0.so.0* $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libatk-1.0.so.0.*
	touch -c $(TARGET_DIR)/lib/libatk-1.0.so.0

atk: libglib2 pkgconfig $(TARGET_DIR)/lib/libatk-1.0.so.0

atk-clean:
	rm -f $(TARGET_DIR)/lib/$(ATK_BINARY)
	-$(MAKE) -C $(ATK_DIR) clean

atk-dirclean:
	rm -rf $(ATK_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ATK)),y)
TARGETS+=atk
endif
