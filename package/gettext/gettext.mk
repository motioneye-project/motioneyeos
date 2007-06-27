#############################################################
#
# gettext
#
#############################################################
GETTEXT_VER:=0.16.1
GETTEXT_SOURCE:=gettext-$(GETTEXT_VER).tar.gz
GETTEXT_SITE:=http://ftp.gnu.org/pub/gnu/gettext
GETTEXT_DIR:=$(BUILD_DIR)/gettext-$(GETTEXT_VER)
GETTEXT_CAT:=$(ZCAT)
GETTEXT_BINARY:=gettext-runtime/src/gettext
GETTEXT_TARGET_BINARY:=bin/gettext

$(DL_DIR)/$(GETTEXT_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GETTEXT_SITE)/$(GETTEXT_SOURCE)

gettext-source: $(DL_DIR)/$(GETTEXT_SOURCE)

$(GETTEXT_DIR)/.unpacked: $(DL_DIR)/$(GETTEXT_SOURCE)
	$(GETTEXT_CAT) $(DL_DIR)/$(GETTEXT_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(GETTEXT_DIR) package/gettext/ gettext\*.patch
	touch $@

ifeq ($(strip $(BR2_TOOLCHAIN_EXTERNAL)),y)
IGNORE_EXTERNAL_GETTEXT:=--with-included-gettext
endif

$(GETTEXT_DIR)/.configured: $(GETTEXT_DIR)/.unpacked
	(cd $(GETTEXT_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
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
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/bin \
		--sbindir=/sbin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--includedir=/include \
		--mandir=/usr/man \
		--infodir=/usr/info \
		--disable-libasprintf \
		$(IGNORE_EXTERNAL_GETTEXT) \
		$(OPENMP) \
	);
	touch $@

$(GETTEXT_DIR)/$(GETTEXT_BINARY): $(GETTEXT_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(GETTEXT_DIR)
	touch -c $(GETTEXT_DIR)/$(GETTEXT_BINARY)

$(STAGING_DIR)/$(GETTEXT_TARGET_BINARY): $(GETTEXT_DIR)/$(GETTEXT_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(GETTEXT_DIR) install
	$(SED) 's,/lib/,$(STAGING_DIR)/lib/,g' $(STAGING_DIR)/lib/libgettextlib.la
	$(SED) 's,/lib/,$(STAGING_DIR)/lib/,g' $(STAGING_DIR)/lib/libgettextpo.la
	$(SED) 's,/lib/,$(STAGING_DIR)/lib/,g' $(STAGING_DIR)/lib/libgettextsrc.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgettextlib.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgettextpo.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libgettextsrc.la
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/lib\',g" $(STAGING_DIR)/lib/libintl.la
	rm -f $(STAGING_DIR)/bin/autopoint $(STAGING_DIR)/bin/envsubst
	rm -f $(STAGING_DIR)/bin/gettext.sh $(STAGING_DIR)/bin/gettextize
	rm -f $(STAGING_DIR)/bin/msg* $(STAGING_DIR)/bin/?gettext
	touch -c $@

gettext: uclibc pkgconfig $(STAGING_DIR)/$(GETTEXT_TARGET_BINARY)

gettext-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GETTEXT_DIR) uninstall
	-$(MAKE) -C $(GETTEXT_DIR) clean

gettext-dirclean:
	rm -rf $(GETTEXT_DIR)

#############################################################
#
# gettext on the target
#
#############################################################

gettext-target: $(GETTEXT_DIR)/$(GETTEXT_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(GETTEXT_DIR) install
	chmod +x $(TARGET_DIR)/lib/libintl.so.3.4.3 # identify as needing to be stripped
	rm -rf  $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc \
		$(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/aclocal \
		$(TARGET_DIR)/usr/include/libintl.h
	-rmdir $(TARGET_DIR)/usr/include

$(TARGET_DIR)/lib/libintl.so: $(STAGING_DIR)/$(GETTEXT_TARGET_BINARY)
	cp -a $(STAGING_DIR)/lib/libgettext*.so* $(TARGET_DIR)/lib/
	cp -a $(STAGING_DIR)/lib/libintl*.so* $(TARGET_DIR)/lib/
	rm -f $(TARGET_DIR)/lib/libgettext*.so*.la $(TARGET_DIR)/lib/libintl*.so*.la
	touch $@

libintl: $(TARGET_DIR)/lib/libintl.so

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBINTL)),y)
TARGETS+=libintl
endif
ifeq ($(strip $(BR2_PACKAGE_GETTEXT)),y)
TARGETS+=gettext
endif
