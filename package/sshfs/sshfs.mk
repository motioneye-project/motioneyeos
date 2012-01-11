#############################################################
#
# sshfs
#
#############################################################

SSHFS_VERSION = 2.3
SSHFS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/fuse/$(SSHFS_VERSION)
SSHFS_SOURCE = sshfs-fuse-$(SSHFS_VERSION).tar.gz
SSHFS_DEPENDENCIES = \
	libglib2 libfuse openssh \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext libintl) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(call AUTOTARGETS))
