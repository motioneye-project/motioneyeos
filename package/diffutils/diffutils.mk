#############################################################
#
# diffutils
#
#############################################################

DIFFUTILS_VERSION = 3.2
DIFFUTILS_SITE = $(BR2_GNU_MIRROR)/diffutils
DIFFUTILS_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_GETTEXT),gettext) \
	$(if $(BR2_PACKAGE_LIBINTL),libintl)

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
DIFFUTILS_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
