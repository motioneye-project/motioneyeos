#############################################################
#
# gtk2-engines.0
#
#############################################################
GTK2_ENGINES_VERSION:=2.9.1
GTK2_ENGINES_SOURCE:=gtk-engines-$(GTK2_ENGINES_VERSION).tar.bz2
GTK2_ENGINES_SITE:=http://ftp.gnome.org/pub/GNOME/sources/gtk-engines/2.9
GTK2_ENGINES_CAT:=$(BZCAT)
GTK2_ENGINES_DIR:=$(BUILD_DIR)/gtk-engines-$(GTK2_ENGINES_VERSION)
GTK2_ENGINES_BINARY:=libclearlooks.so

GTK2_ENGINES_BUILD_ENV=$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		ac_cv_func_mmap_fixed_mapped=yes \
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
		ac_cv_path_CUPS_CONFIG=no


$(DL_DIR)/$(GTK2_ENGINES_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GTK2_ENGINES_SITE)/$(GTK2_ENGINES_SOURCE)

gtk2-engines-source: $(DL_DIR)/$(GTK2_ENGINES_SOURCE)

$(GTK2_ENGINES_DIR)/.unpacked: $(DL_DIR)/$(GTK2_ENGINES_SOURCE)
	$(GTK2_ENGINES_CAT) $(DL_DIR)/$(GTK2_ENGINES_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GTK2_ENGINES_DIR) package/gtk2-engines/ \*.patch*
	$(CONFIG_UPDATE) $(GTK2_ENGINES_DIR)
	touch $(GTK2_ENGINES_DIR)/.unpacked

$(GTK2_ENGINES_DIR)/.configured: $(GTK2_ENGINES_DIR)/.unpacked
	(cd $(GTK2_ENGINES_DIR); rm -rf config.cache; \
		$(GTK2_ENGINES_BUILD_ENV) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libdir=/lib \
		--libexecdir=/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--with-x \
		--x-includes=$(STAGING_DIR)/include \
		--x-libraries=$(STAGING_DIR)/lib \
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
		--disable-deprecated \
	);
	touch $(GTK2_ENGINES_DIR)/.configured

$(GTK2_ENGINES_DIR)/gtk/.libs/$(GTK2_ENGINES_BINARY): $(GTK2_ENGINES_DIR)/.configured
	$(GTK2_ENGINES_BUILD_ENV) $(MAKE) CC=$(TARGET_CC) -C $(GTK2_ENGINES_DIR)
	touch -c $(GTK2_ENGINES_DIR)/gtk/.libs/$(GTK2_ENGINES_BINARY)

$(STAGING_DIR)/lib/$(GTK2_ENGINES_BINARY): $(GTK2_ENGINES_DIR)/gtk/.libs/$(GTK2_ENGINES_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(GTK2_ENGINES_DIR) install;
	touch -c $(STAGING_DIR)/lib/$(GTK2_ENGINES_BINARY)

$(TARGET_DIR)/lib/gtk-2.0/2.10.0/engines/$(GTK2_ENGINES_BINARY): $(STAGING_DIR)/lib/$(GTK2_ENGINES_BINARY)
	mkdir -p $(TARGET_DIR)/lib/gtk-2.0/2.10.0/engines
	cp -a  $(STAGING_DIR)/lib/gtk-2.0/2.10.0/engines/*.so \
		$(TARGET_DIR)/lib/gtk-2.0/2.10.0/engines/
	mkdir -p $(TARGET_DIR)/usr/usr/share/themes
	cp -a $(STAGING_DIR)/usr/share/themes/Clearlooks \
		$(TARGET_DIR)/usr/share/themes/
	touch -c $(TARGET_DIR)/lib/gtk-2.0/2.10.0/engines/$(GTK2_ENGINES_BINARY)

gtk2-engines: libgtk2 $(TARGET_DIR)/lib/gtk-2.0/2.10.0/engines/$(GTK2_ENGINES_BINARY)

gtk2-engines-clean:
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(GTK2_ENGINES_DIR) uninstall;
	-$(MAKE) -C $(GTK2_ENGINES_DIR) clean

gtk2-engines-dirclean:
	rm -rf $(GTK2_ENGINES_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_GTK2_ENGINES)),y)
TARGETS+=gtk2-engines
endif
