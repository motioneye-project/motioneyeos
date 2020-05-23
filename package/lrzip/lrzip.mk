################################################################################
#
# lrzip
#
################################################################################

LRZIP_VERSION = 7f3bf46203bf45ea115d8bd9f310ea219be88af4
LRZIP_SITE = $(call github,ckolivas,lrzip,$(LRZIP_VERSION))
LRZIP_AUTORECONF = YES
LRZIP_LICENSE = GPL-2.0+
LRZIP_LICENSE_FILES = COPYING
LRZIP_DEPENDENCIES = zlib lzo bzip2

ifeq ($(BR2_i386)$(BR2_x86_64),y)
LRZIP_DEPENDENCIES += host-nasm
LRZIP_CONF_OPTS += --enable-asm
else
LRZIP_CONF_OPTS += --disable-asm
endif

$(eval $(autotools-package))
