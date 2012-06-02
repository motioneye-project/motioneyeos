#############################################################
#
# QUOTA
#
#############################################################

QUOTA_VERSION = 4.00
QUOTA_SOURCE = quota-$(QUOTA_VERSION).tar.gz
QUOTA_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/linuxquota/quota-tools/$(QUOTA_VERSION)

QUOTA_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

# Package uses autoconf but not automake.
QUOTA_INSTALL_TARGET_OPT = \
	ROOTDIR=$(TARGET_DIR) \
	install

$(eval $(call AUTOTARGETS))
