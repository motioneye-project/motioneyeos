################################################################################
#
# kodi-vfs-sftp
#
################################################################################

KODI_VFS_SFTP_VERSION = 4e385ae0f82c062add44bce4a2d6a9058a3e0f48
KODI_VFS_SFTP_SITE = $(call github,xbmc,vfs.sftp,$(KODI_VFS_SFTP_VERSION))
KODI_VFS_SFTP_LICENSE = GPL-2.0+
KODI_VFS_SFTP_LICENSE_FILES = src/SFTPFile.cpp
KODI_VFS_SFTP_DEPENDENCIES = kodi-platform libplatform libssh

$(eval $(cmake-package))
