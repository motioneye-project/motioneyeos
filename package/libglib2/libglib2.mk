################################################################################
#
# libglib2
#
################################################################################

LIBGLIB2_VERSION_MAJOR = 2.54
LIBGLIB2_VERSION = $(LIBGLIB2_VERSION_MAJOR).2
LIBGLIB2_SOURCE = glib-$(LIBGLIB2_VERSION).tar.xz
LIBGLIB2_SITE = http://ftp.gnome.org/pub/gnome/sources/glib/$(LIBGLIB2_VERSION_MAJOR)
LIBGLIB2_LICENSE = LGPL-2.0+
LIBGLIB2_LICENSE_FILES = COPYING
# 0002-disable-tests.patch
LIBGLIB2_AUTORECONF = YES

LIBGLIB2_INSTALL_STAGING = YES
LIBGLIB2_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) LDFLAGS=-L$(STAGING_DIR)/usr/lib install

LIBGLIB2_CONF_ENV = \
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
	ac_cv_path_GLIB_GENMARSHAL=$(HOST_DIR)/bin/glib-genmarshal \
	ac_cv_prog_F77=no \
	ac_cv_func_posix_getgrgid_r=no \
	glib_cv_long_long_format=ll \
	ac_cv_func_printf_unix98=yes \
	ac_cv_func_vsnprintf_c99=yes \
	ac_cv_func_newlocale=no \
	ac_cv_func_uselocale=no \
	ac_cv_func_strtod_l=no \
	ac_cv_func_strtoll_l=no \
	ac_cv_func_strtoull_l=no \
	gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no)

# old uClibc versions don't provide qsort_r
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_UCLIBC),y)
LIBGLIB2_CONF_ENV += glib_cv_have_qsort_r=no
else
LIBGLIB2_CONF_ENV += glib_cv_have_qsort_r=yes
endif

# glib/valgrind.h contains inline asm not compatible with thumb1
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
LIBGLIB2_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -marm"
endif

HOST_LIBGLIB2_CONF_OPTS = \
	--disable-coverage \
	--disable-dtrace \
	--disable-fam \
	--disable-libelf \
	--disable-selinux \
	--disable-systemtap \
	--disable-xattr \
	--with-pcre=system

LIBGLIB2_DEPENDENCIES = \
	host-pkgconf host-libglib2 \
	libffi pcre util-linux zlib $(TARGET_NLS_DEPENDENCIES)

HOST_LIBGLIB2_DEPENDENCIES = \
	host-gettext \
	host-libffi \
	host-pcre \
	host-pkgconf \
	host-util-linux \
	host-zlib

LIBGLIB2_CONF_OPTS = \
	--with-pcre=system \
	--disable-compile-warnings

ifneq ($(BR2_ENABLE_LOCALE),y)
LIBGLIB2_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
LIBGLIB2_CONF_OPTS += --enable-libelf
LIBGLIB2_DEPENDENCIES += elfutils
else
LIBGLIB2_CONF_OPTS += --disable-libelf
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
LIBGLIB2_CONF_OPTS += --with-libiconv=gnu
LIBGLIB2_DEPENDENCIES += libiconv
endif

# Purge gdb-related files
ifneq ($(BR2_PACKAGE_GDB),y)
define LIBGLIB2_REMOVE_GDB_FILES
	rm -rf $(TARGET_DIR)/usr/share/glib-2.0/gdb
endef
endif

# Purge useless binaries from target
define LIBGLIB2_REMOVE_DEV_FILES
	rm -rf $(TARGET_DIR)/usr/lib/glib-2.0
	rm -rf $(addprefix $(TARGET_DIR)/usr/share/glib-2.0/,codegen gettext)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gdbus-codegen glib-compile-schemas glib-compile-resources glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
	$(LIBGLIB2_REMOVE_GDB_FILES)
endef

LIBGLIB2_POST_INSTALL_TARGET_HOOKS += LIBGLIB2_REMOVE_DEV_FILES

# Remove schema sources/DTDs, we use staging ones to compile them.
# Do so at target finalization since other packages install additional
# ones and we want to deal with it in a single place.
define LIBGLIB2_REMOVE_TARGET_SCHEMAS
	rm -f $(TARGET_DIR)/usr/share/glib-2.0/schemas/*.xml \
		$(TARGET_DIR)/usr/share/glib-2.0/schemas/*.dtd
endef

# Compile schemas at target finalization since other packages install
# them as well, and better do it in a central place.
# It's used at run time so it doesn't matter defering it.
define LIBGLIB2_COMPILE_SCHEMAS
	$(HOST_DIR)/bin/glib-compile-schemas \
		$(STAGING_DIR)/usr/share/glib-2.0/schemas \
		--targetdir=$(TARGET_DIR)/usr/share/glib-2.0/schemas
endef

LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_REMOVE_TARGET_SCHEMAS
LIBGLIB2_TARGET_FINALIZE_HOOKS += LIBGLIB2_COMPILE_SCHEMAS

$(eval $(autotools-package))
$(eval $(host-autotools-package))

LIBGLIB2_HOST_BINARY = $(HOST_DIR)/bin/glib-genmarshal
