#############################################################
#
# ntfsprogs
#
#############################################################
NTFSPROGS_VERSION:=2.0.0
NTFSPROGS_SOURCE:=ntfsprogs-$(NTFSPROGS_VERSION).tar.gz
NTFSPROGS_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/linux-ntfs/
NTFSPROGS_CONF_OPT:=--disable-gnome-vfs --program-prefix="" --disable-crypto
NTFSPROGS_INSTALL_STAGING:=yes

NTFSPROGS_BIN:=ntfscat ntfscluster ntfscmp ntfsfix ntfsinfo ntfsls
NTFSPROGS_SBIN:=ntfsclone ntfscp ntfslabel ntfsresize ntfsundelete mkntfs

ifeq ($(BR2_PACKAGE_LIBFUSE),y)
NTFSPROGS_DEPENDENCIES += libfuse
endif

define NTFSPROGS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libntfs.so*
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,$(NTFSPROGS_BIN))
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,$(NTFSPROGS_SBIN))
	-unlink $(TARGET_DIR)/sbin/mkfs.ntfs
endef

$(eval $(call AUTOTARGETS,package,ntfsprogs))
