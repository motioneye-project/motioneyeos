################################################################################
#
# samba4
#
################################################################################

SAMBA4_VERSION = 4.1.11
SAMBA4_SITE = http://ftp.samba.org/pub/samba/stable
SAMBA4_SOURCE = samba-$(SAMBA4_VERSION).tar.gz
SAMBA4_LICENSE = GPLv3+
SAMBA4_LICENSE_FILES = COPYING
SAMBA4_DEPENDENCIES = host-e2fsprogs host-heimdal e2fsprogs popt python zlib \
	$(if $(BR2_PACKAGE_LIBCAP),libcap) \
	$(if $(BR2_PACKAGE_READLINE),readline)

ifeq ($(BR2_PACKAGE_ACL),y)
	SAMBA4_CONF_OPT += --with-acl-support
	SAMBA4_DEPENDENCIES += acl
else
	SAMBA4_CONF_OPT += --without-acl-support
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
	SAMBA4_CONF_ENV += CUPS_CONFIG="$(STAGING_DIR)/usr/bin/cups-config"
	SAMBA4_CONF_OPT += --enable-cups
	SAMBA4_DEPENDENCIES += cups
else
	SAMBA4_CONF_OPT += --disable-cups
endif

ifeq ($(BR2_PACKAGE_LIBAIO),y)
	SAMBA4_CONF_OPT += --with-aio-support
	SAMBA4_DEPENDENCIES += libaio
else
	SAMBA4_CONF_OPT += --without-aio-support
endif

ifeq ($(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_AVAHI_DAEMON),yy)
	SAMBA4_CONF_OPT += --enable-avahi
	SAMBA4_DEPENDENCIES += avahi
else
	SAMBA4_CONF_OPT += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_GAMIN),y)
	SAMBA4_CONF_OPT += --with-fam
	SAMBA4_DEPENDENCIES += gamin
else
	SAMBA4_CONF_OPT += --without-fam
endif

ifeq ($(BR2_PACKAGE_GETTEXT),y)
	SAMBA4_CONF_OPT += --with-gettext=$(STAGING_DIR)/usr
	SAMBA4_DEPENDENCIES += gettext
else
	SAMBA4_CONF_OPT += --without-gettext
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
	SAMBA4_CONF_OPT += --enable-gnutls
	SAMBA4_DEPENDENCIES += gnutls
else
	SAMBA4_CONF_OPT += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_FORM)$(BR2_PACKAGE_NCURSES_TARGET_MENU)$(BR2_PACKAGE_NCURSES_TARGET_PANEL),yyy)
	SAMBA4_DEPENDENCIES += ncurses
else
	SAMBA4_CONF_OPT += --without-regedit
endif

define SAMBA4_CONFIGURE_CMDS
	cp package/samba4/samba4-cache.txt $(@D)/cache.txt;
	echo 'Checking uname machine type: $(BR2_ARCH)' >>$(@D)/cache.txt;
	(cd $(@D); \
		PYTHON_CONFIG="$(STAGING_DIR)/usr/bin/python-config" \
		python_LDFLAGS="" \
		python_LIBDIR="" \
		$(TARGET_CONFIGURE_OPTS) \
		$(SAMBA4_CONF_ENV) \
		./buildtools/bin/waf configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-libiconv=$(STAGING_DIR)/usr \
			--enable-fhs \
			--cross-compile \
			--cross-answers=$(@D)/cache.txt \
			--hostcc=gcc \
			--disable-rpath \
			--disable-rpath-install \
			--disable-iprint \
			--without-pam \
			--without-dmapi \
			--disable-glusterfs \
			--without-ldap \
			--without-cluster-support \
			--without-ads \
			--bundled-libraries='!asn1_compile,!compile_et' \
			$(SAMBA4_CONF_OPT) \
	)
endef

define SAMBA4_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SAMBA4_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

# Samba just installs .py files so the purge causes problems with some tools
ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY),y)
define SAMBA4_BUILD_PYC_FILES
	PYTHONPATH="$(PYTHON_PATH)" \
		$(HOST_DIR)/usr/bin/python -c "import compileall; \
		compileall.compile_dir('$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/samba')"
endef
SAMBA4_POST_INSTALL_TARGET_HOOKS += SAMBA4_BUILD_PYC_FILES
endif

define SAMBA4_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/samba4/S91smb \
		$(TARGET_DIR)/etc/init.d/S91smb
endef

# uClibc-based builds don't like libtalloc in /usr/lib/samba
define SAMBA4_MOVE_TALLOC
	mv -f $(TARGET_DIR)/usr/lib/samba/libtalloc* $(TARGET_DIR)/usr/lib
endef

SAMBA4_POST_INSTALL_TARGET_HOOKS += SAMBA4_MOVE_TALLOC

$(eval $(generic-package))
