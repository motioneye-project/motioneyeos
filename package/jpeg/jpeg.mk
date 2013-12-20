################################################################################
#
# jpeg
#
################################################################################

JPEG_SOURCE =
JPEG_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_JPEG))

ifeq ($(JPEG_DEPENDENCIES),)
define JPEG_CONFIGURE_CMDS
	echo "No JPEG implementation defined. Configuration error"
	exit 1
endef
endif

$(eval $(generic-package))
