#############################################################
#
# samba
#
#############################################################
SAMBA_VERSION:=3.2.5
SAMBA_SOURCE:=samba-$(SAMBA_VERSION).tar.gz
SAMBA_SITE:=http://samba.org/samba/ftp/stable/
SAMBA_DIR:=$(BUILD_DIR)/samba-$(SAMBA_VERSION)/source
SAMBA_CAT:=$(ZCAT)
SAMBA_BINARY:=bin/smbd
SAMBA_TARGET_BINARY:=usr/sbin/smbd

$(DL_DIR)/$(SAMBA_SOURCE):
	$(WGET) -P $(DL_DIR) $(SAMBA_SITE)/$(SAMBA_SOURCE)

$(SAMBA_DIR)/.unpacked: $(DL_DIR)/$(SAMBA_SOURCE)
	$(SAMBA_CAT) $(DL_DIR)/$(SAMBA_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh `dirname $(SAMBA_DIR)` package/samba/ samba\*.patch
	$(CONFIG_UPDATE) $(SAMBA_DIR)
	touch $@

$(SAMBA_DIR)/.configured: $(SAMBA_DIR)/.unpacked
	(cd $(SAMBA_DIR); rm -rf config.cache; \
		./autogen.sh; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
		samba_cv_USE_SETREUID=yes \
		samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
		samba_cv_HAVE_IFACE_IFCONF=yes \
		samba_cv_HAVE_MMAP=yes \
		samba_cv_HAVE_FCNTL_LOCK=yes \
		samba_cv_HAVE_SECURE_MKSTEMP=yes \
		samba_cv_HAVE_NATIVE_ICONV=no \
		samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
		samba_cv_fpie=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--localstatedir=/var \
		--with-lockdir=/var/cache/samba \
		--with-piddir=/var/run \
		--with-privatedir=/etc/samba \
		--with-logfilebase=/var/log/samba \
		--with-configdir=/etc/samba \
		--with-libiconv=$(STAGING_DIR) \
		--without-ldap \
		--without-ads \
		--without-acl \
		--with-included-popt \
		--with-included-iniparser \
		--disable-shared-libs \
		--disable-static \
		--disable-cups \
		$(BR2_LARGEFILE) \
	)
	touch $@

$(SAMBA_DIR)/$(SAMBA_BINARY): $(SAMBA_DIR)/.configured
	$(MAKE) -C $(SAMBA_DIR) proto
	$(MAKE) -C $(SAMBA_DIR)

SAMBA_TARGETS_ :=
SAMBA_TARGETS_y :=

SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_CIFS) += usr/sbin/mount.cifs \
						   usr/sbin/umount.cifs
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_EVENTLOGADM) += usr/bin/eventlogadm
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_FINDSMB) += usr/bin/findsmb
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_NET) += usr/bin/net
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_NMBD) += usr/sbin/nmbd
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_NMBLOOKUP) += usr/bin/nmblookup
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_NTLM_AUTH) += usr/bin/ntlm_auth
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_PDBEDIT) += usr/bin/pdbedit
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_PROFILES) += usr/bin/profiles
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_RPCCLIENT) += usr/bin/rpcclient
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBCACLS) += usr/bin/smbcacls
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBCLIENT) += usr/bin/smbclient
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBCONTROL) += usr/bin/smbcontrol
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBCQUOTAS) += usr/bin/smbcquotas
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBGET) += usr/bin/smbget
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBPASSWD) += usr/bin/smbpasswd
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBSPOOL) += usr/bin/smbspool
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBSTATUS) += usr/bin/smbstatus
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBTAR) += usr/bin/smbtar
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SMBTREE) += usr/bin/smbtree
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_SWAT) += usr/sbin/swat
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbbackup \
						   usr/bin/tdbdump \
						   usr/bin/tdbtool
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_TESTPARM) += usr/bin/testparm
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_WINBINDD) += usr/sbin/winbindd
SAMBA_TARGETS_$(BR2_PACKAGE_SAMBA_WBINFO) += usr/bin/wbinfo

$(TARGET_DIR)/$(SAMBA_TARGET_BINARY): $(SAMBA_DIR)/$(SAMBA_BINARY)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) \
		prefix="${TARGET_DIR}/usr" \
		BASEDIR="${TARGET_DIR}/usr" \
		SBINDIR="${TARGET_DIR}/usr/sbin" \
		LOCKDIR="${TARGET_DIR}/var/cache/samba" \
		PRIVATEDIR="${TARGET_DIR}/etc/samba" \
		CONFIGDIR="${TARGET_DIR}/etc/samba" \
		VARDIR="${TARGET_DIR}/var/log/samba" \
		-C $(SAMBA_DIR) installlibs installservers installbin installcifsmount installscripts
	# Do not install the LDAP-like embedded database tools
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/ldb, add del edit modify search)
	# Remove not used library by Samba binaries
	rm -f $(TARGET_DIR)/usr/lib/libnetapi*
	rm -f $(TARGET_DIR)/usr/lib/libsmbclient*
	rm -f $(TARGET_DIR)/usr/lib/libtalloc*
	rm -f $(TARGET_DIR)/usr/lib/libtdb*
	# Remove not wanted Samba binaries
	for file in $(SAMBA_TARGETS_); do \
		rm -f $(TARGET_DIR)/$$file; \
	done
	# Strip the wanted Samba binaries
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/$(SAMBA_TARGET_BINARY)
	for file in $(SAMBA_TARGETS_y); do \
		$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/$$file; \
	done
ifeq ($(BR2_PACKAGE_SAMBA_SWAT),y)
	cp -dpfr $(SAMBA_DIR)/../swat $(TARGET_DIR)/usr/
endif
	$(INSTALL) -m 0755 package/samba/S91smb $(TARGET_DIR)/etc/init.d
	@if [ ! -f $(TARGET_DIR)/etc/samba/smb.conf ]; then \
		$(INSTALL) -m 0755 -D package/samba/simple.conf $(TARGET_DIR)/etc/samba/smb.conf; \
	fi
	rm -rf $(TARGET_DIR)/var/cache/samba
	rm -rf $(TARGET_DIR)/var/lib/samba

samba: libiconv $(TARGET_DIR)/$(SAMBA_TARGET_BINARY)

samba-source: $(DL_DIR)/$(SAMBA_SOURCE)

samba-unpacked: $(SAMBA_DIR)/.unpacked

samba-clean:
	rm -f $(TARGET_DIR)/$(SAMBA_TARGET_BINARY)
	for file in $(SAMBA_TARGETS_y); do \
		rm -f $(TARGET_DIR)/$$file; \
	done
	rm -f $(TARGET_DIR)/etc/init.d/S91smb
	rm -rf $(TARGET_DIR)/etc/samba
	-$(MAKE) -C $(SAMBA_DIR) clean

samba-dirclean:
	rm -rf $(SAMBA_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_SAMBA),y)
TARGETS+=samba
endif
