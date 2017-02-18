################################################################################
#
# sshfs
#
################################################################################

SSHFS_VERSION = 2.7
SSHFS_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs-$(SSHFS_VERSION)
SSHFS_LICENSE = GPLv2
SSHFS_LICENSE_FILES = COPYING
SSHFS_DEPENDENCIES = \
	libglib2 libfuse openssh \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
