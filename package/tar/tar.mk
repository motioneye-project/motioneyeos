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
HOST_TAR_DEPENDENCIES =
endif

$(eval $(autotools-package))

# host-tar: use cpio.gz instead of tar.gz to prevent chicken-egg problem
# of needing tar to build tar.
HOST_TAR_SOURCE = tar-$(TAR_VERSION).cpio.gz
define HOST_TAR_EXTRACT_CMDS
	mkdir -p $(@D)
	cd $(@D) && \
		$(INFLATE.gz) $(DL_DIR)/$(HOST_TAR_SOURCE) | cpio -i
	mv $(@D)/tar-$(TAR_VERSION)/* $(@D)
	rmdir $(@D)/tar-$(TAR_VERSION)
endef
$(eval $(host-autotools-package))
