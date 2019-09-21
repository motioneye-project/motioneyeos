################################################################################
#
# kodi-vfs-rar
#
################################################################################

KODI_VFS_RAR_VERSION = 60f92ff28ee6c94211b628990696c60518bffcf6
KODI_VFS_RAR_SITE = $(call github,xbmc,vfs.rar,$(KODI_VFS_RAR_VERSION))
KODI_VFS_RAR_LICENSE = unrar, GPL-2.0+
KODI_VFS_RAR_LICENSE_FILES = lib/UnrarXLib/license.txt src/RarManager.h
KODI_VFS_RAR_DEPENDENCIES = libplatform kodi

$(eval $(cmake-package))
