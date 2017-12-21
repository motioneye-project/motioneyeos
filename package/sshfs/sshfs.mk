################################################################################
#
# sshfs
#
################################################################################

SSHFS_VERSION = 2.8
SSHFS_SITE = https://github.com/libfuse/sshfs/releases/download/sshfs_$(SSHFS_VERSION)
SSHFS_LICENSE = GPL-2.0
SSHFS_LICENSE_FILES = COPYING
SSHFS_DEPENDENCIES = \
	libglib2 libfuse openssh \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
