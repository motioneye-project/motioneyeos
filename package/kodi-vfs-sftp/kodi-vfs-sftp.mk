################################################################################
#
# kodi-vfs-sftp
#
################################################################################

KODI_VFS_SFTP_VERSION = 1.0.6-Leia
KODI_VFS_SFTP_SITE = $(call github,xbmc,vfs.sftp,$(KODI_VFS_SFTP_VERSION))
KODI_VFS_SFTP_LICENSE = GPL-2.0+
KODI_VFS_SFTP_LICENSE_FILES = LICENSE.md
KODI_VFS_SFTP_DEPENDENCIES = kodi-platform libplatform libssh

$(eval $(cmake-package))
