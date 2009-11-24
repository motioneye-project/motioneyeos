#############################################################
#
# sshfs
#
#############################################################

SSHFS_VERSION:=2.2
SSHFS_SOURCE:=sshfs-fuse-$(SSHFS_VERSION).tar.gz
SSHFS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/fuse/$(SSHFS_VERSION)/sshfs-fuse
SSHFS_AUTORECONF:=NO
SSHFS_INSTALL_STAGING:=NO
SSHFS_INSTALL_TARGET:=YES

SSHFS_DEPENDENCIES = libglib2 libfuse

$(eval $(call AUTOTARGETS,package,sshfs))
