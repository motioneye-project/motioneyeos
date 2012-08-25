#############################################################
#
# QUOTA
#
#############################################################

QUOTA_VERSION = 4.00
QUOTA_SOURCE = quota-$(QUOTA_VERSION).tar.gz
QUOTA_SITE = http://downloads.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)

QUOTA_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
QUOTA_DEPENDENCIES = gettext libintl
QUOTA_MAKE_OPT += LDFLAGS="$(TARGET_LDFLAGS) -lintl"
endif

# Package uses autoconf but not automake.
QUOTA_INSTALL_TARGET_OPT = \
	ROOTDIR=$(TARGET_DIR) \
	install

$(eval $(autotools-package))
