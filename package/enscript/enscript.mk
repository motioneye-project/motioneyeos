################################################################################
#
# enscript
#
################################################################################

ENSCRIPT_VERSION = 1.6.6
ENSCRIPT_SITE = $(BR2_GNU_MIRROR)/enscript
ENSCRIPT_LICENSE = GPL-3.0+
ENSCRIPT_LICENSE_FILES = COPYING

# Enable pthread threads if toolchain supports threads
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
ENSCRIPT_CONF_OPTS += --enable-threads=pth
else
ENSCRIPT_CONF_OPTS += --disable-threads
endif

$(eval $(autotools-package))
