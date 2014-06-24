################################################################################
#
# sysprof
#
################################################################################

SYSPROF_VERSION = 1.2.0
SYSPROF_SITE = http://sysprof.com
SYSPROF_DEPENDENCIES = libglib2
SYSPROF_LICENSE = GPLv2+
SYSPROF_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_SYSPROF_GUI),y)
SYSPROF_DEPENDENCIES += libgtk2 libglade gdk-pixbuf
endif

define SYSPROF_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

SYSPROF_POST_PATCH_HOOKS += SYSPROF_CREATE_M4_DIR

$(eval $(autotools-package))
