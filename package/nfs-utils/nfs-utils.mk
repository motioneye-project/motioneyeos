################################################################################
#
# nfs-utils
#
################################################################################

NFS_UTILS_VERSION = 1.2.6
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VERSION).tar.bz2
NFS_UTILS_SITE = http://downloads.sourceforge.net/project/nfs/nfs-utils/$(NFS_UTILS_VERSION)
NFS_UTILS_LICENSE = GPLv2+
NFS_UTILS_LICENSE_FILES = COPYING
NFS_UTILS_AUTORECONF = YES
NFS_UTILS_DEPENDENCIES = host-pkgconf

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPT = \
		--disable-nfsv4 \
		--disable-nfsv41 \
		--disable-gss \
		--disable-uuid \
		--disable-ipv6 \
		--without-tcp-wrappers \
		--with-rpcgen=internal

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
NFS_UTILS_CONF_OPT += --enable-tirpc --with-tirpcinclude=$(STAGING_DIR)/usr/include/tirpc/
NFS_UTILS_DEPENDENCIES += libtirpc
else
NFS_UTILS_CONF_OPT += --disable-tirpc
endif

define NFS_UTILS_INSTALL_FIXUP
	$(INSTALL) -m 0755 package/nfs-utils/S60nfs \
		$(TARGET_DIR)/etc/init.d/S60nfs
	rm -f $(NFS_UTILS_TARGETS_)
endef

define NFS_UTILS_REMOVE_NFSIOSTAT
	rm -f $(TARGET_DIR)/usr/sbin/nfsiostat
endef

NFS_UTILS_POST_INSTALL_TARGET_HOOKS += NFS_UTILS_INSTALL_FIXUP

# nfsiostat is interpreted python, so remove it unless it's in the target
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += $(if $(BR2_PACKAGE_PYTHON),,NFS_UTILS_REMOVE_NFSIOSTAT)

$(eval $(autotools-package))
