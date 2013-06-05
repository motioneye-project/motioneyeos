################################################################################
#
# sshfs
#
################################################################################

SSHFS_VERSION = 2.4
SSHFS_SITE = http://downloads.sourceforge.net/project/fuse/sshfs-fuse/$(SSHFS_VERSION)
SSHFS_SOURCE = sshfs-fuse-$(SSHFS_VERSION).tar.gz
SSHFS_LICENSE = GPLv2
SSHFS_LICENSE_FILES = COPYING
SSHFS_DEPENDENCIES = \
	libglib2 libfuse openssh \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
