################################################################################
#
# sysprof
#
################################################################################

SYSPROF_VERSION = 1.2.0
SYSPROF_SITE = http://sysprof.com
SYSPROF_DEPENDENCIES = libglib2
SYSPROF_LICENSE = GPL-2.0+
SYSPROF_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_SYSPROF_GUI),y)
SYSPROF_DEPENDENCIES += libgtk2 libglade gdk-pixbuf
endif

$(eval $(autotools-package))
