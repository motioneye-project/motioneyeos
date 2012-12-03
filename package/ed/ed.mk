#############################################################
#
# ed
#
#############################################################

ED_VERSION = 1.7
ED_SITE = $(BR2_GNU_MIRROR)/ed
ED_CONF_OPT = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
ED_LICENSE = GPLv3+
ED_LICENSE_FILES = COPYING

$(eval $(autotools-package))
