################################################################################
#
# jpeg
#
################################################################################

JPEG_SOURCE =

ifeq ($(BR2_PACKAGE_JPEG_TURBO),y)
JPEG_DEPENDENCIES += jpeg-turbo
endif

ifeq ($(BR2_PACKAGE_LIBJPEG),y)
JPEG_DEPENDENCIES += libjpeg
endif

ifeq ($(JPEG_DEPENDENCIES),)
define JPEG_CONFIGURE_CMDS
	echo "No JPEG implementation defined. Configuration error"
	exit 1
endef
endif

$(eval $(generic-package))
