################################################################################
#
# nfs-utils
#
################################################################################

NFS_UTILS_VERSION = 1.3.3
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VERSION).tar.xz
NFS_UTILS_SITE = https://www.kernel.org/pub/linux/utils/nfs-utils/$(NFS_UTILS_VERSION)
NFS_UTILS_LICENSE = GPL-2.0+
NFS_UTILS_LICENSE_FILES = COPYING
NFS_UTILS_AUTORECONF = YES
NFS_UTILS_DEPENDENCIES = host-pkgconf

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPTS = \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--disable-gss \
	--disable-uuid \
	--disable-ipv6 \
	--without-tcp-wrappers \
	--with-statedir=/run/nfs \
	--with-rpcgen=internal

HOST_NFS_UTILS_CONF_OPTS = \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--disable-gss \
	--disable-uuid \
	--disable-ipv6 \
	--without-tcp-wrappers \
	--with-statedir=/run/nfs \
	--disable-caps \
	--disable-tirpc \
	--without-systemd \
	--with-rpcgen=internal
HOST_NFS_UTILS_DEPENDENCIES = host-pkgconf host-libtirpc

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad

ifeq ($(BR2_PACKAGE_LIBCAP),y)
NFS_UTILS_CONF_OPTS += --enable-caps
NFS_UTILS_DEPENDENCIES += libcap
else
NFS_UTILS_CONF_OPTS += --disable-caps
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
NFS_UTILS_CONF_OPTS += --enable-tirpc
NFS_UTILS_DEPENDENCIES += libtirpc
else
NFS_UTILS_CONF_OPTS += --disable-tirpc
endif

define NFS_UTILS_INSTALL_FIXUP
	rm -f $(NFS_UTILS_TARGETS_)
	touch $(TARGET_DIR)/etc/exports
	$(INSTALL) -D -m 644 \
		$(@D)/utils/mount/nfsmount.conf $(TARGET_DIR)/etc/nfsmount.conf
endef
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += NFS_UTILS_INSTALL_FIXUP

ifeq ($(BR2_INIT_SYSTEMD),y)
NFS_UTILS_CONF_OPTS += --with-systemd=/usr/lib/systemd/system
NFS_UTILS_DEPENDENCIES += systemd
else
NFS_UTILS_CONF_OPTS += --without-systemd
endif

define NFS_UTILS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/nfs-utils/S60nfs \
		$(TARGET_DIR)/etc/init.d/S60nfs
endef

define NFS_UTILS_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/nfs-server.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nfs-server.service
	ln -fs ../../../../usr/lib/systemd/system/nfs-client.target \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nfs-client.target

	mkdir -p $(TARGET_DIR)/etc/systemd/system/remote-fs.target.wants

	ln -fs ../../../../usr/lib/systemd/system/nfs-client.target \
		$(TARGET_DIR)/etc/systemd/system/remote-fs.target.wants/nfs-client.target

	$(INSTALL) -D -m 0755 package/nfs-utils/nfs-utils_env.sh \
		$(TARGET_DIR)/usr/lib/systemd/scripts/nfs-utils_env.sh

	$(INSTALL) -D -m 0644 package/nfs-utils/nfs-utils_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/nfs-utils.conf
endef

define NFS_UTILS_REMOVE_NFSIOSTAT
	rm -f $(TARGET_DIR)/usr/sbin/nfsiostat
endef

# nfsiostat is interpreted python, so remove it unless it's in the target
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += $(if $(BR2_PACKAGE_PYTHON),,NFS_UTILS_REMOVE_NFSIOSTAT)

define HOST_NFS_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D)/tools/rpcgen
endef

define HOST_NFS_UTILS_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/rpcgen/rpcgen $(HOST_DIR)/bin/rpcgen
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
