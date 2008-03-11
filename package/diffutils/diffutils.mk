#############################################################
#
# diffutils
#
#############################################################
DIFFUTILS_VERSION=2.8.7
DIFFUTILS_SOURCE:=diffutils-$(DIFFUTILS_VERSION).tar.gz
#DIFFUTILS_SITE:=ftp://alpha.gnu.org/gnu/diffutils/
DIFFUTILS_SITE:=$(BR2_GNU_MIRROR)/gnu/diffutils
DIFFUTILS_CAT:=$(ZCAT)
DIFFUTILS_DIR:=$(BUILD_DIR)/diffutils-$(DIFFUTILS_VERSION)
DIFFUTILS_BINARY:=src/diff
DIFFUTILS_TARGET_BINARY:=usr/bin/diff

$(DL_DIR)/$(DIFFUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(DIFFUTILS_SITE)/$(DIFFUTILS_SOURCE)

diffutils-source: $(DL_DIR)/$(DIFFUTILS_SOURCE)

$(DIFFUTILS_DIR)/.unpacked: $(DL_DIR)/$(DIFFUTILS_SOURCE)
	$(DIFFUTILS_CAT) $(DL_DIR)/$(DIFFUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(DIFFUTILS_DIR)/config
	touch $@

$(DIFFUTILS_DIR)/.configured: $(DIFFUTILS_DIR)/.unpacked
	(cd $(DIFFUTILS_DIR); rm -rf config.cache; \
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
		am_cv_func_working_getline=yes \
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
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(DIFFUTILS_DIR)/$(DIFFUTILS_BINARY): $(DIFFUTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(DIFFUTILS_DIR)

$(TARGET_DIR)/$(DIFFUTILS_TARGET_BINARY): $(DIFFUTILS_DIR)/$(DIFFUTILS_BINARY)
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(DIFFUTILS_DIR) install
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc

diffutils: uclibc $(TARGET_DIR)/$(DIFFUTILS_TARGET_BINARY)

diff-utils-unpacked: $(DIFFUTILS_DIR)/.unpacked

diffutils-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(DIFFUTILS_DIR) uninstall
	-$(MAKE) -C $(DIFFUTILS_DIR) clean

diffutils-dirclean:
	rm -rf $(DIFFUTILS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_DIFFUTILS)),y)
TARGETS+=diffutils
endif
