#############################################################
#
# automake
#
#############################################################
AUTOMAKE_VERSION:=1.10
AUTOMAKE_SOURCE:=automake-$(AUTOMAKE_VERSION).tar.bz2
AUTOMAKE_SITE:=$(BR2_GNU_MIRROR)/automake
AUTOMAKE_CAT:=$(BZCAT)
AUTOMAKE_SRC_DIR:=$(TOOL_BUILD_DIR)/automake-$(AUTOMAKE_VERSION)
AUTOMAKE_DIR:=$(BUILD_DIR)/automake-$(AUTOMAKE_VERSION)
AUTOMAKE_HOST_DIR:=$(TOOL_BUILD_DIR)/automake-$(AUTOMAKE_VERSION)-host
AUTOMAKE_BINARY:=automake
AUTOMAKE_TARGET_BINARY:=usr/bin/automake
AUTOMAKE:=$(STAGING_DIR)/usr/bin/automake

# variables used by other packages
ACLOCAL_DIR = $(STAGING_DIR)/usr/share/aclocal
ACLOCAL = aclocal -I $(ACLOCAL_DIR)

$(DL_DIR)/$(AUTOMAKE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(AUTOMAKE_SITE)/$(AUTOMAKE_SOURCE)

automake-source: $(DL_DIR)/$(AUTOMAKE_SOURCE)

$(AUTOMAKE_SRC_DIR)/.unpacked: $(DL_DIR)/$(AUTOMAKE_SOURCE)
	$(AUTOMAKE_CAT) $(DL_DIR)/$(AUTOMAKE_SOURCE) | tar -C $(TOOL_BUILD_DIR) $(TAR_OPTIONS) -
	$(CONFIG_UPDATE) $(AUTOMAKE_SRC_DIR)
	touch $@

#############################################################
#
# automake for the target
#
#############################################################

$(AUTOMAKE_DIR)/.configured: $(AUTOMAKE_SRC_DIR)/.unpacked
	mkdir -p $(AUTOMAKE_DIR)
	(cd $(AUTOMAKE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		WANT_AUTOCONF=2.5 \
		$(AUTOMAKE_SRC_DIR)/configure \
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
		--includedir=/usr/include \
	)
	touch $@

$(AUTOMAKE_DIR)/$(AUTOMAKE_BINARY): $(AUTOMAKE_DIR)/.configured
	$(MAKE) -C $(AUTOMAKE_DIR)
	touch -c $@

$(TARGET_DIR)/$(AUTOMAKE_TARGET_BINARY): $(AUTOMAKE_DIR)/$(AUTOMAKE_BINARY)
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
	    -C $(AUTOMAKE_DIR) install
ifneq ($(BR2_HAVE_INFOPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/info
endif
ifneq ($(BR2_HAVE_MANPAGES),y)
	rm -rf $(TARGET_DIR)/usr/share/man
endif
	rm -rf $(TARGET_DIR)/share/locale
	rm -rf $(TARGET_DIR)/usr/share/doc
	touch -c $@

automake: uclibc autoconf $(TARGET_DIR)/$(AUTOMAKE_TARGET_BINARY)

automake-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(AUTOMAKE_DIR) uninstall
	-$(MAKE) -C $(AUTOMAKE_DIR) clean

automake-dirclean:
	rm -rf $(AUTOMAKE_DIR)

#############################################################
#
# automake for the host
#
#############################################################

$(AUTOMAKE_HOST_DIR)/.configured: $(AUTOMAKE_SRC_DIR)/.unpacked
	mkdir -p $(AUTOMAKE_HOST_DIR)
	(cd $(AUTOMAKE_HOST_DIR); rm -rf config.cache; \
		$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS)" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		WANT_AUTOCONF=2.5 \
		$(AUTOMAKE_SRC_DIR)/configure \
		--prefix=$(STAGING_DIR)/usr \
	)
	touch $@

$(AUTOMAKE_HOST_DIR)/$(AUTOMAKE_BINARY): $(AUTOMAKE_HOST_DIR)/.configured
	$(MAKE) -C $(AUTOMAKE_HOST_DIR)
	touch -c $@

$(AUTOMAKE): $(AUTOMAKE_HOST_DIR)/$(AUTOMAKE_BINARY)
	$(MAKE) -C $(AUTOMAKE_HOST_DIR) install

host-automake: host-autoconf host-libtool $(AUTOMAKE)

host-automake-clean:
	$(MAKE) -C $(AUTOMAKE_HOST_DIR) uninstall
	-$(MAKE) -C $(AUTOMAKE_HOST_DIR) clean

host-automake-dirclean:
	rm -rf $(AUTOMAKE_HOST_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_AUTOMAKE)),y)
TARGETS+=automake
endif
