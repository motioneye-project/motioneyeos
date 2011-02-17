#############################################################
#
# samba
#
#############################################################
SAMBA_VERSION:=3.3.14
SAMBA_SOURCE:=samba-$(SAMBA_VERSION).tar.gz
SAMBA_SITE:=http://samba.org/samba/ftp/stable/

SAMBA_SUBDIR = source
SAMBA_AUTORECONF = NO

SAMBA_INSTALL_STAGING = YES
SAMBA_INSTALL_TARGET = YES


SAMBA_DEPENDENCIES = \
	$(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(if $(BR2_PACKAGE_SAMBA_RPCCLIENT),readline) \
	$(if $(BR2_PACKAGE_SAMBA_SMBCLIENT),readline) \
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),avahi) \
	$(if $(BR2_PACKAGE_SAMBA_GAMIN),gamin)


SAMBA_CONF_ENV = \
	samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
	samba_cv_USE_SETREUID=yes \
	samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
	samba_cv_HAVE_IFACE_IFCONF=yes \
	samba_cv_HAVE_MMAP=yes \
	samba_cv_HAVE_FCNTL_LOCK=yes \
	samba_cv_HAVE_SECURE_MKSTEMP=yes \
	samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
	samba_cv_fpie=no \
	libreplace_cv_HAVE_IPV6=$(if $(BR2_INET_IPV6),yes,no) \
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),AVAHI_LIBS=-pthread)


SAMBA_CONF_OPT = \
	--localstatedir=/var \
	--with-piddir=/var/run \
	--with-lockdir=/var/lock \
	--with-logfilebase=/var/log \
	--with-configdir=/etc/samba \
	--with-privatedir=/etc/samba \
	\
	--disable-cups \
	--disable-static \
	--enable-shared \
	--enable-shared-libs \
	--disable-pie \
	--disable-relro \
	--disable-dnssd \
	\
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),--enable-avahi,--disable-avahi) \
	$(if $(BR2_PACKAGE_SAMBA_GAMIN),--enable-fam,--disable-fam) \
	$(if $(BR2_PACKAGE_SAMBA_SWAT),--enable-swat,--disable-swat) \
	\
	--without-cluster-support \
	--without-cifsupcall \
	--without-ads \
	--without-ldap \
	--with-included-popt \
	--with-included-iniparser \
	--with-libiconv=$(STAGING_DIR) \
	\
	$(if $(BR2_PACKAGE_SAMBA_CIFS),--with-cifsmount,--without-cifsmount) \
	$(if $(BR2_PACKAGE_SAMBA_RPCCLIENT),--with-readline=$(STAGING_DIR)) \
	$(if $(BR2_PACKAGE_SAMBA_SMBCLIENT),--with-readline=$(STAGING_DIR)) \
	$(if $(BR2_PACKAGE_SAMBA_WINBINDD),--with-winbind,--without-winbind)


SAMBA_INSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR) -C $(SAMBA_DIR)/$(SAMBA_SUBDIR) \
	installlibs installservers installbin installscripts \
	$(if $(BR2_PACKAGE_SAMBA_CIFS),installcifsmount) \
	$(if $(BR2_PACKAGE_SAMBA_SWAT),installswat)


SAMBA_UNINSTALL_TARGET_OPT = \
	DESTDIR=$(TARGET_DIR) -C $(SAMBA_DIR)/$(SAMBA_SUBDIR) \
	uninstalllibs uninstallservers uninstallbin uninstallscripts \
	$(if $(BR2_PACKAGE_SAMBA_CIFS),uninstallcifsmount) \
	$(if $(BR2_PACKAGE_SAMBA_SWAT),uninstallswat)


# binaries to keep
SAMBA_BINTARGETS_y = \
	usr/sbin/smbd \
	usr/lib/libtalloc.so \
	usr/lib/libtdb.so


# binaries to remove
SAMBA_BINTARGETS_ = \
	usr/lib/libnetapi.so* \
	usr/lib/libsmbsharemodes.so*


# binaries to keep or remove
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_CIFS) += usr/sbin/mount.cifs
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_CIFS) += usr/sbin/umount.cifs
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_EVENTLOGADM) += usr/bin/eventlogadm
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NET) += usr/bin/net
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NMBD) += usr/sbin/nmbd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NMBLOOKUP) += usr/bin/nmblookup
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NTLM_AUTH) += usr/bin/ntlm_auth
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_PDBEDIT) += usr/bin/pdbedit
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_PROFILES) += usr/bin/profiles
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_RPCCLIENT) += usr/bin/rpcclient
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCACLS) += usr/bin/smbcacls
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCLIENT) += usr/bin/smbclient
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCONTROL) += usr/bin/smbcontrol
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCQUOTAS) += usr/bin/smbcquotas
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBGET) += usr/bin/smbget
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbadd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbdel
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbedit
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbmodify
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbrename
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbsearch
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBPASSWD) += usr/bin/smbpasswd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSHARESEC) += usr/bin/sharesec
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSPOOL) += usr/bin/smbspool
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSTATUS) += usr/bin/smbstatus
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBTREE) += usr/bin/smbtree
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SWAT) += usr/sbin/swat
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbbackup
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbdump
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbtool
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TESTPARM) += usr/bin/testparm
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WINBINDD) += usr/sbin/winbindd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WBINFO) += usr/bin/wbinfo

# libraries to keep or remove
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WINBINDD) += usr/lib/libwbclient.so*
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_LIBSMBCLIENT) += usr/lib/libsmbclient.so*


# non-binaries to remove
SAMBA_TXTTARGETS_ = \
	usr/include/libsmbclient.h \
	usr/include/netapi.h \
	usr/include/smb_share_modes.h \
	usr/include/talloc.h \
	usr/include/tdb.h \
	usr/include/wbclient.h


# non-binaries to keep or remove
SAMBA_TXTTARGETS_$(BR2_PACKAGE_SAMBA_FINDSMB) += usr/bin/findsmb
SAMBA_TXTTARGETS_$(BR2_PACKAGE_SAMBA_SMBTAR) += usr/bin/smbtar

define SAMBA_REMOVE_UNNEEDED_BINARIES
	rm -f $(addprefix $(TARGET_DIR)/, $(SAMBA_BINTARGETS_))
	rm -f $(addprefix $(TARGET_DIR)/, $(SAMBA_TXTTARGETS_))
endef

SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_REMOVE_UNNEEDED_BINARIES

define SAMBA_REMOVE_SWAT_DOCUMENTATION
	# Remove the documentation
	rm -rf $(TARGET_DIR)/usr/swat/help/manpages
	rm -rf $(TARGET_DIR)/usr/swat/help/Samba3*
	rm -rf $(TARGET_DIR)/usr/swat/using_samba/
	# Removing the welcome.html file will make swat default to
	# welcome-no-samba-doc.html
	rm -rf $(TARGET_DIR)/usr/swat/help/welcome.html
endef

ifeq ($(BR2_PACKAGE_SAMBA_SWAT),y)
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_REMOVE_SWAT_DOCUMENTATION
endif
endif

define SAMBA_INSTALL_INITSCRIPTS_CONFIG
	# install start/stop script
	@if [ ! -f $(TARGET_DIR)/etc/init.d/S91smb ]; then \
		$(INSTALL) -m 0755 -D package/samba/S91smb $(TARGET_DIR)/etc/init.d/S91smb; \
	fi
	# install config
	@if [ ! -f $(TARGET_DIR)/etc/samba/smb.conf ]; then \
		$(INSTALL) -m 0755 -D package/samba/simple.conf $(TARGET_DIR)/etc/samba/smb.conf; \
	fi
endef

SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_INSTALL_INITSCRIPTS_CONFIG

$(eval $(call AUTOTARGETS,package,samba))
