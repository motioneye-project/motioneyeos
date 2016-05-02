################################################################################
#
# samba4
#
################################################################################

SAMBA4_VERSION = 4.4.3
SAMBA4_SITE = http://ftp.samba.org/pub/samba/stable
SAMBA4_SOURCE = samba-$(SAMBA4_VERSION).tar.gz
SAMBA4_INSTALL_STAGING = YES
SAMBA4_LICENSE = GPLv3+
SAMBA4_LICENSE_FILES = COPYING
SAMBA4_DEPENDENCIES = \
	host-e2fsprogs host-heimdal host-python \
	e2fsprogs popt python zlib \
	$(if $(BR2_PACKAGE_LIBAIO),libaio) \
	$(if $(BR2_PACKAGE_LIBBSD),libbsd) \
	$(if $(BR2_PACKAGE_LIBCAP),libcap) \
	$(if $(BR2_PACKAGE_READLINE),readline)

ifeq ($(BR2_PACKAGE_ACL),y)
SAMBA4_CONF_OPTS += --with-acl-support
SAMBA4_DEPENDENCIES += acl
else
SAMBA4_CONF_OPTS += --without-acl-support
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
SAMBA4_CONF_ENV += CUPS_CONFIG="$(STAGING_DIR)/usr/bin/cups-config"
SAMBA4_CONF_OPTS += --enable-cups
SAMBA4_DEPENDENCIES += cups
else
SAMBA4_CONF_OPTS += --disable-cups
endif

ifeq ($(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_AVAHI_DAEMON),yy)
SAMBA4_CONF_OPTS += --enable-avahi
SAMBA4_DEPENDENCIES += avahi
else
SAMBA4_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_GAMIN),y)
SAMBA4_CONF_OPTS += --with-fam
SAMBA4_DEPENDENCIES += gamin
else
SAMBA4_CONF_OPTS += --without-fam
endif

ifeq ($(BR2_PACKAGE_GETTEXT),y)
SAMBA4_DEPENDENCIES += gettext
else
SAMBA4_CONF_OPTS += --without-gettext
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
SAMBA4_CONF_OPTS += --enable-gnutls
SAMBA4_DEPENDENCIES += gnutls
else
SAMBA4_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_NCURSES_TARGET_FORM)$(BR2_PACKAGE_NCURSES_TARGET_MENU)$(BR2_PACKAGE_NCURSES_TARGET_PANEL),yyy)
SAMBA4_CONF_ENV += NCURSES_CONFIG="$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)"
SAMBA4_DEPENDENCIES += ncurses
else
SAMBA4_CONF_OPTS += --without-regedit
endif

# The ctdb tests (cluster) need bash and take up some space
# They're normally intended for debugging so remove them
define SAMBA4_REMOVE_CTDB_TESTS
	rm -rf $(TARGET_DIR)/usr/lib/ctdb-tests
	rm -rf $(TARGET_DIR)/usr/share/ctdb-tests
	rm -f $(TARGET_DIR)/usr/bin/ctdb_run_*tests
endef
SAMBA4_POST_INSTALL_TARGET_HOOKS += SAMBA4_REMOVE_CTDB_TESTS

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
			--with-cluster-support \
			--bundled-libraries='!asn1_compile,!compile_et' \
			$(SAMBA4_CONF_OPTS) \
	)
endef

define SAMBA4_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SAMBA4_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
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

ifeq ($(BR2_PACKAGE_SAMBA4_AD_DC),)
SAMBA4_CONF_OPTS += --without-ad-dc
endif

ifeq ($(BR2_PACKAGE_SAMBA4_ADS),y)
SAMBA4_CONF_OPTS += --with-ads --with-ldap --with-shared-modules=idmap_ad
SAMBA4_DEPENDENCIES += openldap
else
SAMBA4_CONF_OPTS += --without-ads --without-ldap
endif

ifeq ($(BR2_PACKAGE_SAMBA4_SMBTORTURE),)
define SAMBA4_REMOVE_SMBTORTURE
	rm -f $(TARGET_DIR)/usr/bin/smbtorture
endef
SAMBA4_POST_INSTALL_TARGET_HOOKS += SAMBA4_REMOVE_SMBTORTURE
endif

define SAMBA4_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/samba4/S91smb \
		$(TARGET_DIR)/etc/init.d/S91smb
endef

define SAMBA4_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)/packaging/systemd/nmb.service \
		$(TARGET_DIR)/usr/lib/systemd/system/nmb.service
	$(INSTALL) -D -m 644 $(@D)/packaging/systemd/smb.service \
		$(TARGET_DIR)/usr/lib/systemd/system/smb.service
	$(INSTALL) -D -m 644 $(@D)/packaging/systemd/winbind.service \
		$(TARGET_DIR)/usr/lib/systemd/system/winbind.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/nmb.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nmb.service
	ln -sf ../../../../usr/lib/systemd/system/smb.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/smb.service
	ln -sf ../../../../usr/lib/systemd/system/winbind.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/winbind.service
endef

$(eval $(generic-package))
