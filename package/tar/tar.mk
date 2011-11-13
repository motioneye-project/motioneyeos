#############################################################
#
# tar
#
#############################################################

TAR_VERSION = 1.26
TAR_SITE = $(BR2_GNU_MIRROR)/tar

# Prefer full-blown tar over buybox's version
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
TAR_DEPENDENCIES += busybox
endif

$(eval $(call AUTOTARGETS))
