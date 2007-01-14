#############################################################
#
# libgtk2.0
#
#############################################################
LIBGTK2_VERSION:=2.10.7
LIBGTK2_SOURCE:=gtk+-$(LIBGTK2_VERSION).tar.bz2
LIBGTK2_SITE:=ftp://ftp.gtk.org/pub/gtk/v2.10
LIBGTK2_CAT:=$(BZCAT)
LIBGTK2_DIR:=$(BUILD_DIR)/gtk+-$(LIBGTK2_VERSION)
LIBGTK2_BINARY:=libgtk-x11-2.0.a


$(DL_DIR)/$(LIBGTK2_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LIBGTK2_SITE)/$(LIBGTK2_SOURCE)

libgtk2-source: $(DL_DIR)/$(LIBGTK2_SOURCE)

$(LIBGTK2_DIR)/.unpacked: $(DL_DIR)/$(LIBGTK2_SOURCE)
	$(LIBGTK2_CAT) $(DL_DIR)/$(LIBGTK2_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBGTK2_DIR) package/libgtk2/ \*.patch*
	$(CONFIG_UPDATE) $(LIBGTK2_DIR)
	touch $(LIBGTK2_DIR)/.unpacked

$(LIBGTK2_DIR)/.configured: $(LIBGTK2_DIR)/.unpacked
	(cd $(LIBGTK2_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		GLIB_CONFIG=$(STAGING_DIR)/bin/glib-config \
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
		ac_cv_path_CUPS_CONFIG=no \
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
		--with-x \
		--x-includes=$(STAGING_DIR)/usr/X11R6/include \
		--x-libraries=$(STAGING_DIR)/usr/X11R6/lib \
		--disable-glibtest \
		--enable-explicit-deps=no \
		--disable-debug \
		--disable-glibtest \
		--disable-xim \
		--with-gdktarget=x11 \
	);
	touch $(LIBGTK2_DIR)/.configured

$(LIBGTK2_DIR)/gtk/.libs/$(LIBGTK2_BINARY): $(LIBGTK2_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBGTK2_DIR)
	touch -c $(LIBGTK2_DIR)/gtk/.libs/$(LIBGTK2_BINARY)

$(STAGING_DIR)/lib/$(LIBGTK2_BINARY): $(LIBGTK2_DIR)/gtk/.libs/$(LIBGTK2_BINARY)
	$(MAKE) prefix=$(STAGING_DIR) \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/bin \
	    datadir=$(STAGING_DIR)/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    sharedstatedir=$(STAGING_DIR)/com \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    includedir=$(STAGING_DIR)/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
	    -C $(LIBGTK2_DIR) install;
	touch -c $(STAGING_DIR)/lib/$(LIBGTK2_BINARY)

$(TARGET_DIR)/lib/libgtk-x11-2.0.so.0: $(STAGING_DIR)/lib/$(LIBGTK2_BINARY)
	cp -a $(STAGING_DIR)/lib/libgtk-x11-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgtk-x11-2.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgdk*-2.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libgdk*-2.0.so.0* $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgtk-x11-2.0.so.0*
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgdk*-2.0.so.0*
	touch -c $(TARGET_DIR)/lib/libgtk-x11-2.0.so.0

libgtk2: uclibc png jpeg tiff xorg libglib2 \
	cairo pango atk $(TARGET_DIR)/lib/libgtk-x11-2.0.so.0

libgtk2-clean:
	rm -f $(TARGET_DIR)/lib/libgtk* $(TARGET_DIR)/lib/libgdk*
	-$(MAKE) -C $(LIBGTK2_DIR) clean

libgtk2-dirclean:
	rm -rf $(LIBGTK2_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBGTK2)),y)
TARGETS+=libgtk2
endif
