#############################################################
#
# nfs-utils
#
#############################################################
NFS_UTILS_VERSION = 1.2.3
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VERSION).tar.bz2
NFS_UTILS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/nfs/

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPT = \
		--disable-nfsv4 \
		--disable-gss \
		--disable-tirpc \
		--disable-uuid \
		--without-tcp-wrappers \
		--with-rpcgen=internal

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad

define NFS_UTILS_INSTALL_FIXUP
	$(INSTALL) -m 0755 package/nfs-utils/S60nfs \
		$(TARGET_DIR)/etc/init.d/S60nfs
	rm -f $(NFS_UTILS_TARGETS_)
endef

NFS_UTILS_POST_INSTALL_TARGET_HOOKS += NFS_UTILS_INSTALL_FIXUP

$(eval $(call AUTOTARGETS,package,nfs-utils))
