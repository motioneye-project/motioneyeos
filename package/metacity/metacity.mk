#############################################################
#
# metacity
#
#############################################################

# Seems to be broken -- topbar icons and such are misplaced etc
#METACITY_VERSION:=2.17.5

METACITY_VERSION:=2.16.3
METACITY_SOURCE:=metacity-$(METACITY_VERSION).tar.bz2
METACITY_SITE:=http://ftp.gnome.org/pub/gnome/sources/metacity/2.16
METACITY_DIR:=$(BUILD_DIR)/metacity-$(METACITY_VERSION)
METACITY_CAT:=$(BZCAT)

METACITY_SOURCE2:=MCity-Clearlooks2.tar.gz
METACITY_CAT2:=$(ZCAT)
METACITY_SITE2:=http://art.gnome.org/download/themes/metacity/1190

$(DL_DIR)/$(METACITY_SOURCE):
	 $(WGET) -P $(DL_DIR) $(METACITY_SITE)/$(METACITY_SOURCE)

$(DL_DIR)/$(METACITY_SOURCE2):
	 $(WGET) -P $(DL_DIR) $(METACITY_SITE2)/$(METACITY_SOURCE2)

metacity-source: $(DL_DIR)/$(METACITY_SOURCE) $(DL_DIR)/$(METACITY_SOURCE2)

$(METACITY_DIR)/.unpacked: $(DL_DIR)/$(METACITY_SOURCE) $(DL_DIR)/$(METACITY_SOURCE2)
	$(METACITY_CAT) $(DL_DIR)/$(METACITY_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(METACITY_DIR) package/metacity/ \*.patch*
	(cd $(METACITY_DIR); libtoolize --force;)
	$(CONFIG_UPDATE) $(METACITY_DIR)
	(cd $(METACITY_DIR); autoconf;)
	touch $(METACITY_DIR)/.unpacked

$(METACITY_DIR)/.configured: $(METACITY_DIR)/.unpacked
	(cd $(METACITY_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		PKG_CONFIG=$(STAGING_DIR)/usr/bin/pkg-config \
		GLIB_CONFIG=$(STAGING_DIR)/bin/glib-config \
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
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec_prefix=/ \
		--libexecdir=/ \
		--libdir=/lib \
		--x-includes=$(STAGING_DIR)/usr/X11R6/include \
		--x-libraries=$(STAGING_DIR)/usr/X11R6/lib \
		--disable-glibtest \
		--disable-gconf \
		--disable-dependency-tracking \
		--disable-sm \
		--disable-nls \
		--disable-startup-notification \
	)
	touch $(METACITY_DIR)/.configured

$(METACITY_DIR)/.compiled: $(METACITY_DIR)/.configured
	$(MAKE) -C $(METACITY_DIR)
	touch $(METACITY_DIR)/.compiled

$(STAGING_DIR)/lib/*metacity*.so: $(METACITY_DIR)/.compiled
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(METACITY_DIR) install
	touch -c $(STAGING_DIR)/lib/*metacity*.so

$(TARGET_DIR)/lib/*metacity*.so: $(STAGING_DIR)/lib/*metacity*.so
	cp -dpf $(STAGING_DIR)/lib/*metacity*.so* $(TARGET_DIR)/lib/
	-$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/lib/*metacity*.so
	cp -dpf $(STAGING_DIR)/bin/*metacity* $(TARGET_DIR)/bin/
	mkdir -p $(TARGET_DIR)/usr/share/metacity/icons
	cp -dpf $(STAGING_DIR)/usr/share/metacity/icons/* $(TARGET_DIR)/usr/share/metacity/icons/
	mkdir -p $(TARGET_DIR)/usr/share/themes
	$(METACITY_CAT2) $(DL_DIR)/$(METACITY_SOURCE2) | \
		tar -C $(STAGING_DIR)/usr/share/themes $(TAR_OPTIONS) -
	cp -a $(STAGING_DIR)/usr/share/themes/Clearlooks \
		$(TARGET_DIR)/usr/share/themes/
	(cd $(TARGET_DIR)/usr/share/themes; rm -rf Atlanta; ln -s Clearlooks Atlanta)
	cp package/metacity/Xsession $(TARGET_DIR)/etc/X11/

metacity: uclibc zlib $(XSERVER) libgtk2 $(TARGET_DIR)/lib/*metacity*.so

metacity-clean:
	-$(MAKE) -C $(METACITY_DIR) clean

metacity-dirclean:
	rm -rf $(METACITY_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_METACITY)),y)
TARGETS+=metacity
endif
