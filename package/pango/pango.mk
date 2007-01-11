#############################################################
#
# pango
#
#############################################################
PANGO_VERSION:=1.13.5
#PANGO_VERSION:=1.14.8
PANGO_SOURCE:=pango-$(PANGO_VERSION).tar.bz2
#PANGO_SITE:=ftp://ftp.gtk.org/pub/pango/1.14
PANGO_SITE:=ftp://ftp.gtk.org/pub/pango/1.13
PANGO_CAT:=$(BZCAT)
PANGO_DIR:=$(BUILD_DIR)/pango-$(PANGO_VERSION)
PANGO_BINARY:=libpango-1.0.a

ifeq ($(BR2_ENDIAN),"BIG")
PANGO_BE:=yes
else
PANGO_BE:=no
endif

PANGO_BUILD_ENV=$(TARGET_CONFIGURE_OPTS) \
		PKG_CONFIG=$(STAGING_DIR)/usr/bin/pkg-config \
		ac_cv_c_bigendian=$(PANGO_BE) \
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
		ac_cv_path_FREETYPE_CONFIG=$(STAGING_DIR)/bin/freetype-config

$(DL_DIR)/$(PANGO_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PANGO_SITE)/$(PANGO_SOURCE)

pango-source: $(DL_DIR)/$(PANGO_SOURCE)

$(PANGO_DIR)/.unpacked: $(DL_DIR)/$(PANGO_SOURCE)
	$(PANGO_CAT) $(DL_DIR)/$(PANGO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(PANGO_DIR) package/pango/ \*.patch*
	$(CONFIG_UPDATE) $(PANGO_DIR)
	touch $(PANGO_DIR)/.unpacked

$(PANGO_DIR)/.configured: $(PANGO_DIR)/.unpacked
	(cd $(PANGO_DIR); rm -rf config.cache; \
		 $(PANGO_BUILD_ENV) \
		./configure \
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=$(STAGING_DIR) \
		--exec_prefix=$(STAGING_DIR) \
		--libdir=$(STAGING_DIR)/lib \
		--includedir=$(STAGING_DIR)/include \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
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
	touch $(PANGO_DIR)/.configured

$(PANGO_DIR)/pango/.libs/$(PANGO_BINARY): $(PANGO_DIR)/.configured
	$(PANGO_BUILD_ENV) $(MAKE1) CC=$(TARGET_CC) -C $(PANGO_DIR)
	touch -c $(PANGO_DIR)/pango/.libs/$(PANGO_BINARY)

$(STAGING_DIR)/lib/$(PANGO_BINARY): $(PANGO_DIR)/pango/.libs/$(PANGO_BINARY)
	$(MAKE) prefix=$(STAGING_DIR) \
	    exec_prefix=$(STAGING_DIR) \
	    bindir=$(STAGING_DIR)/bin \
	    sbindir=$(STAGING_DIR)/sbin \
	    libexecdir=$(STAGING_DIR)/libexec \
	    datadir=$(STAGING_DIR)/share \
	    sysconfdir=$(STAGING_DIR)/etc \
	    sharedstatedir=$(STAGING_DIR)/com \
	    localstatedir=$(STAGING_DIR)/var \
	    libdir=$(STAGING_DIR)/lib \
	    includedir=$(STAGING_DIR)/include \
	    oldincludedir=$(STAGING_DIR)/include \
	    infodir=$(STAGING_DIR)/info \
	    mandir=$(STAGING_DIR)/man \
	    -C $(PANGO_DIR) install;

$(TARGET_DIR)/lib/libpango-1.0.so.0: $(STAGING_DIR)/lib/$(PANGO_BINARY)
	cp -a $(STAGING_DIR)/lib/libpango-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpango-1.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangox-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangox-1.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangoft2-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangoft2-1.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangoxft-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangoxft-1.0.so.0* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangocairo-1.0.so $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libpangocairo-1.0.so.0* $(TARGET_DIR)/lib/
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libpango-1.0.so.0.*
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgpangox-1.0.so.0.*
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgoft2-1.0.so.0.*
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgoxft-1.0.so.0.*
	$(STRIP) --strip-unneeded $(TARGET_DIR)/lib/libgocairo-1.0.so.0.*
	touch -c $(TARGET_DIR)/lib/libpango-1.0.so.0

pango: uclibc gettext libintl pkgconfig libglib2 xorg cairo \
	$(TARGET_DIR)/lib/libpango-1.0.so.0

pango-clean:
	rm -f $(TARGET_DIR)/lib/$(PANGO_BINARY)
	-$(MAKE) -C $(PANGO_DIR) clean

pango-dirclean:
	rm -rf $(PANGO_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PANGO)),y)
TARGETS+=pango
endif
