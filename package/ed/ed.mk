#############################################################
#
# ed
#
#############################################################

ED_VERSION = 1.6
ED_SITE = $(BR2_GNU_MIRROR)/ed
ED_CONF_OPT = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"

$(eval $(autotools-package))
