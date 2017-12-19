################################################################################
#
# modplugtools
#
################################################################################

MODPLUGTOOLS_VERSION = 0.5.3
MODPLUGTOOLS_SITE = http://downloads.sourceforge.net/project/modplug-xmms/modplug-tools
MODPLUGTOOLS_LICENSE = GPL-3.0
MODPLUGTOOLS_LICENSE_FILES = COPYING

MODPLUGTOOLS_DEPENDENCIES = libao libmodplug

# Only build the 'mp123' subdir, which contains 'modplug123' that plays through
# various backends via libao. This excludes the 'mpplay' subdir, which contains
# 'modplugplay' that can play only through the deprecated OSS interface.
MODPLUGTOOLS_MAKE_OPTS = SUBDIRS=mp123
MODPLUGTOOLS_INSTALL_TARGET_OPTS = SUBDIRS=mp123 DESTDIR=$(TARGET_DIR) install

$(eval $(autotools-package))
