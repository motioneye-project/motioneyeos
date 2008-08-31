#############################################################
#
# avahi (zeroconf implementation)
#
#############################################################
#
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software Foundation
# either version 2.1 of the License, or (at your option) any
# later version.

AVAHI_VERSION:=0.6.22
AVAHI_DIR:=$(BUILD_DIR)/avahi-$(AVAHI_VERSION)
AVAHI_SITE:=http://www.avahi.org/download/
AVAHI_SOURCE:=avahi-$(AVAHI_VERSION).tar.gz
AVAHI_CAT:=$(ZCAT)

AVAHI_TARGETS:=

ifeq ($(strip $(BR2_PACKAGE_AVAHI_AUTOIPD)),y)
AVAHI_TARGETS+=$(TARGET_DIR)/usr/sbin/avahi-autoipd
endif

AVAHI_EXTRA_DEPS:=

ifeq ($(strip $(BR2_PACKAGE_AVAHI_DAEMON)),y)
AVAHI_TARGETS+=$(TARGET_DIR)/usr/sbin/avahi-daemon
AVAHI_DISABLE_EXPAT:=--with-xml=expat
# depend on the exact library file instead of expat so avahi isn't always
# considered out-of-date
AVAHI_EXTRA_DEPS+=$(STAGING_DIR)/usr/lib/libexpat.so.1
else
AVAHI_DISABLE_EXPAT:=--disable-expat --with-xml=none

endif

ifeq ($(strip $(BR2_PACKAGE_DBUS)),y)
AVAHI_DISABLE_DBUS:=
AVAHI_EXTRA_DEPS+=$(STAGING_DIR)/usr/bin/dbus-daemon
else
AVAHI_DISABLE_DBUS:=--disable-dbus
endif

$(DL_DIR)/$(AVAHI_SOURCE):
	 $(WGET) -P $(DL_DIR) $(AVAHI_SITE)/$(AVAHI_SOURCE)

avahi-source: $(DL_DIR)/$(AVAHI_SOURCE)

$(AVAHI_DIR)/.unpacked: $(DL_DIR)/$(AVAHI_SOURCE)
	$(AVAHI_CAT) $(DL_DIR)/$(AVAHI_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(AVAHI_DIR) package/avahi/ \*.patch
	touch $@

$(AVAHI_DIR)/.configured: $(AVAHI_DIR)/.unpacked $(AVAHI_EXTRA_DEPS)
	(cd $(AVAHI_DIR) && rm -rf config.cache && autoconf)
	(cd $(AVAHI_DIR) && \
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
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-glib \
		--disable-gobject \
		--disable-qt3 \
		--disable-qt4 \
		--disable-gtk \
		$(AVAHI_DISABLE_DBUS) \
		$(AVAHI_DISABLE_EXPAT) \
		--disable-gdbm \
		--disable-python \
		--disable-python-dbus \
		--disable-pygtk \
		--disable-mono \
		--disable-monodoc \
		--disable-stack-protector \
		--with-distro=none \
		--with-avahi-user=default \
		--with-avahi-group=default \
		--with-autoipd-user=default \
		--with-autoipd-group=default \
	)
	touch $@

$(AVAHI_DIR)/.compiled: $(AVAHI_DIR)/.configured
	$(MAKE) -C $(AVAHI_DIR) $(if $(BR2_ENABLE_LOCALE),LIBS=-lintl)
	touch $@

$(AVAHI_DIR)/.installed: $(AVAHI_DIR)/.compiled
	mkdir -p $(STAGING_DIR)/etc/avahi
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(AVAHI_DIR) install
	touch $@

$(TARGET_DIR)/usr/sbin/avahi-autoipd: $(AVAHI_DIR)/.installed
	mkdir -p $(TARGET_DIR)/etc/avahi
	mkdir -p $(TARGET_DIR)/etc/init.d
	mkdir -p $(TARGET_DIR)/var/lib
	mkdir -p $(TARGET_DIR)/usr/share/udhcpc
	cp -af $(STAGING_DIR)/etc/avahi/avahi-autoipd.action $(TARGET_DIR)/etc/avahi/
	cp -af package/avahi/busybox-udhcpc-default.script $(TARGET_DIR)/usr/share/udhcpc/default.script
	chmod 0755 $(TARGET_DIR)/usr/share/udhcpc/default.script
	cp -af package/avahi/S05avahi-setup.sh $(TARGET_DIR)/etc/init.d/
	cp $(STAGING_DIR)/usr/sbin/avahi-autoipd $(TARGET_DIR)/usr/sbin/avahi-autoipd
	ln -sf /tmp/avahi-autoipd $(TARGET_DIR)/var/lib/avahi-autoipd
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@

$(TARGET_DIR)/usr/sbin/avahi-daemon: $(AVAHI_DIR)/.installed
	mkdir -p $(TARGET_DIR)/etc/avahi/services $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/libavahi-*.so* $(TARGET_DIR)/usr/lib/
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libavahi-*.so*
	cp -af $(STAGING_DIR)/etc/avahi/avahi-daemon.conf $(TARGET_DIR)/etc/avahi/
	cp -af package/avahi/S50avahi-daemon $(TARGET_DIR)/etc/init.d/
ifeq ($(strip $(BR2_PACKAGE_DBUS)),y)
	cp -dpf $(STAGING_DIR)/usr/bin/avahi-* $(TARGET_DIR)/usr/bin
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/bin/avahi-*
	mkdir -p $(TARGET_DIR)/etc/dbus-1/system.d/
	cp -r $(STAGING_DIR)/etc/dbus-1/system.d/avahi-* \
		$(TARGET_DIR)/etc/dbus-1/system.d/
endif
	cp $(STAGING_DIR)/usr/sbin/avahi-daemon \
		 $(TARGET_DIR)/usr/sbin/avahi-daemon
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $@

avahi: uclibc libdaemon $(AVAHI_TARGETS) $(if $(BR2_ENABLE_LOCALE),gettext libintl)

avahi-clean:
	-$(MAKE) -C $(AVAHI_DIR) distclean
	-rm -rf $(TARGET_DIR)/etc/avahi
	-rm -f $(TARGET_DIR)/var/lib/avahi-autoipd
	-rm -f $(TARGET_DIR)/etc/init.d/S*avahi*
	-rm -f $(TARGET_DIR)/usr/sbin/avahi-*
	-rm -f $(TARGET_DIR)/usr/bin/avahi-*
	-rm -f $(TARGET_DIR)/usr/lib/libavahi-*

avahi-dirclean:
	rm -rf $(AVAHI_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_AVAHI)),y)
TARGETS+=avahi
endif
