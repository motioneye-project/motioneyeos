#############################################################
#
# m4
#
#############################################################
M4_VERSION:=1.4.9
M4_SOURCE:=m4-$(M4_VERSION).tar.bz2
M4_CAT:=$(BZCAT)
M4_SITE:=$(BR2_GNU_MIRROR)/m4
M4_DIR:=$(BUILD_DIR)/m4-$(M4_VERSION)
M4_HOST_DIR:=$(TOOL_BUILD_DIR)/m4-$(M4_VERSION)
M4_BINARY:=m4
M4_TARGET_BINARY:=usr/bin/m4

ifeq ($(UCLIBC_HAS_REGEX),y)
gl_cv_func_re_compile_pattern_working=gl_cv_func_re_compile_pattern_working=yes
endif
ifneq ($(UCLIBC_HAS_WCHAR),y)
gt_cv_c_wchar_t=gt_cv_c_wchar_t=no
gl_cv_absolute_wchar_h=gl_cv_absolute_wchar_h=__fpending.h
endif

$(DL_DIR)/$(M4_SOURCE):
	 $(WGET) -P $(DL_DIR) $(M4_SITE)/$(M4_SOURCE)

m4-source: $(DL_DIR)/$(M4_SOURCE)

$(M4_DIR)/.unpacked: $(DL_DIR)/$(M4_SOURCE)
	$(M4_CAT) $(DL_DIR)/$(M4_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(M4_DIR) package/m4 m4\*.patch
	$(CONFIG_UPDATE) $(@D)
	touch $@

$(M4_DIR)/.configured: $(M4_DIR)/.unpacked
	(cd $(M4_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		gl_cv_func_gettimeofday_clobber=no \
		$(gl_cv_func_re_compile_pattern_working) \
		$(gt_cv_c_wchar_t) \
		$(gl_cv_absolute_wchar_h) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(M4_DIR)/src/$(M4_BINARY): $(M4_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) RANLIB=$(TARGET_RANLIB) AR=$(TARGET_AR) -C $(M4_DIR)

$(TARGET_DIR)/$(M4_TARGET_BINARY): $(M4_DIR)/src/$(M4_BINARY)
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/share/info \
	    mandir=$(TARGET_DIR)/usr/share/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(M4_DIR) install
	$(STRIPCMD) $(TARGET_DIR)/$(M4_TARGET_BINARY) > /dev/null 2>&1
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc
	touch -c $@

m4: uclibc $(TARGET_DIR)/$(M4_TARGET_BINARY)

m4-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(M4_DIR) uninstall
	-$(MAKE) -C $(M4_DIR) clean

m4-dirclean:
	rm -rf $(M4_DIR)

#############################################################
#
# m4 for the host
#
#############################################################

$(M4_HOST_DIR)/.unpacked: $(DL_DIR)/$(M4_SOURCE)
	$(M4_CAT) $(DL_DIR)/$(M4_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(M4_HOST_DIR) package/m4 m4\*.patch
	$(CONFIG_UPDATE) $(@D)
	touch $@

$(M4_HOST_DIR)/.configured: $(M4_HOST_DIR)/.unpacked
	(cd $(M4_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		gl_cv_func_gettimeofday_clobber=no \
		$(gl_cv_func_re_compile_pattern_working) \
		./configure \
		--prefix=$(STAGING_DIR)/usr \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(M4_HOST_DIR)/src/$(M4_BINARY): $(M4_HOST_DIR)/.configured
	$(MAKE) -C $(M4_HOST_DIR)

$(STAGING_DIR)/$(M4_TARGET_BINARY): $(M4_HOST_DIR)/src/$(M4_BINARY)
	$(MAKE) -C $(M4_HOST_DIR) install

host-m4: uclibc $(STAGING_DIR)/$(M4_TARGET_BINARY)

host-m4-clean:
	$(MAKE) -C $(M4_HOST_DIR) uninstall
	-$(MAKE) -C $(M4_HOST_DIR) clean

host-m4-dirclean:
	rm -rf $(M4_HOST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_M4),y)
TARGETS+=m4
endif
