#############################################################
#
# nfs-utils
#
#############################################################
NFS_UTILS_VER:=1.0.10
NFS_UTILS_SOURCE:=nfs-utils-$(NFS_UTILS_VER).tar.gz
NFS_UTILS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nfs/
NFS_UTILS_CAT:=$(ZCAT)
NFS_UTILS_DIR:=$(BUILD_DIR)/nfs-utils-$(NFS_UTILS_VER)
NFS_UTILS_BINARY:=utils/nfsd/nfsd
NFS_UTILS_TARGET_BINARY:=usr/sbin/rpc.nfsd

BR2_NFS_UTILS_CFLAGS=
ifeq ($(BR2_LARGEFILE),)
BR2_NFS_UTILS_CFLAGS+=-U_LARGEFILE64_SOURCE -U_FILE_OFFSET_BITS
endif
BR2_NFS_UTILS_CFLAGS+=-DUTS_RELEASE='\"$(LINUX_HEADERS_VERSION)\"'


$(DL_DIR)/$(NFS_UTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(NFS_UTILS_SITE)/$(NFS_UTILS_SOURCE)

nfs-utils-source: $(DL_DIR)/$(NFS_UTILS_SOURCE)

$(NFS_UTILS_DIR)/.unpacked: $(DL_DIR)/$(NFS_UTILS_SOURCE)
	$(NFS_UTILS_CAT) $(DL_DIR)/$(NFS_UTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(NFS_UTILS_DIR) package/nfs-utils/ nfs-utils*.patch
	toolchain/patch-kernel.sh $(NFS_UTILS_DIR) $(NFS_UTILS_DIR)/debian/ *.patch
	$(CONFIG_UPDATE) $(NFS_UTILS_DIR)
	touch $@

$(NFS_UTILS_DIR)/.configured: $(NFS_UTILS_DIR)/.unpacked
	(cd $(NFS_UTILS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(BR2_NFS_UTILS_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		knfsd_cv_bsd_signals=no \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--disable-nfsv4 \
		--disable-gss \
	);
	touch $@

$(NFS_UTILS_DIR)/$(NFS_UTILS_BINARY): $(NFS_UTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) CC_FOR_BUILD="$(HOSTCC)" \
		RPCGEN=/usr/bin/rpcgen -C $(NFS_UTILS_DIR)
	touch -c $(NFS_UTILS_DIR)/$(NFS_UTILS_BINARY)

NFS_UTILS_TARGETS_  :=
NFS_UTILS_TARGETS_y :=	usr/sbin/exportfs usr/sbin/rpc.mountd	\
			usr/sbin/rpc.nfsd usr/sbin/rpc.statd

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG)	+= usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD)	+= usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD)	+= usr/sbin/rpc.rquotad

$(STAGING_DIR)/.fakeroot.nfs-utils: $(NFS_UTILS_DIR)/$(NFS_UTILS_BINARY)
	# Use fakeroot to pretend to do 'make install' as root
	echo "$(MAKE) prefix=$(TARGET_DIR)/usr statedir=$(TARGET_DIR)/var/lib/nfs CC=$(TARGET_CC) -C $(NFS_UTILS_DIR) install" > $@
	echo "rm -f $(TARGET_DIR)/usr/bin/event_rpcgen.py $(TARGET_DIR)/usr/sbin/nhfs* $(TARGET_DIR)/usr/sbin/nfsstat $(TARGET_DIR)/usr/sbin/showmount" >> $@
	echo "rm -rf $(TARGET_DIR)/usr/share/man" >> $@
	echo "$(INSTALL) -m 0755 -D package/nfs-utils/S60nfs $(TARGET_DIR)/etc/init.d" >> $@
	echo -n "for file in $(NFS_UTILS_TARGETS_) ; do rm -f $(TARGET_DIR)/" >> $@
	echo -n "\$$" >> $@
	echo "file; done" >> $@
	echo "rm -rf $(TARGET_DIR)/var/lib/nfs" >> $@

$(TARGET_DIR)/$(NFS_UTILS_TARGET_BINARY): $(STAGING_DIR)/.fakeroot.nfs-utils
	touch -c $(TARGET_DIR)/$(NFS_UTILS_TARGET_BINARY)

nfs-utils: uclibc host-fakeroot $(TARGET_DIR)/$(NFS_UTILS_TARGET_BINARY)

nfs-utils-clean:
	rm -f $(TARGET_DIR)/etc/init.d/S60nfs
	for file in $(NFS_UTILS_TARGETS_y) ; do \
		rm -f $(TARGET_DIR)/$$file; \
	done
	-$(MAKE) -C $(NFS_UTILS_DIR) clean
	rm -f $(STAGING_DIR)/.fakeroot.nfs-utils

nfs-utils-dirclean:
	rm -rf $(NFS_UTILS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_NFS_UTILS)),y)
TARGETS+=nfs-utils
endif
