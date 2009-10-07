#############################################################
#
# ntfs-3g
#
#############################################################
NTFS_3G_VERSION:=2009.3.8
NTFS_3G_SOURCE:=ntfs-3g-$(NTFS_3G_VERSION).tgz
NTFS_3G_SITE:=http://www.ntfs-3g.org/
NTFS_3G_CONF_OPT:=--disable-ldconfig --program-prefix=""
NTFS_3G_INSTALL_STAGING:=yes

$(eval $(call AUTOTARGETS,package,ntfs-3g))
