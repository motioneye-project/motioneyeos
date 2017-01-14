################################################################################
#
# jasper
#
################################################################################

JASPER_VERSION = 2.0.10
JASPER_SITE = http://www.ece.uvic.ca/~frodo/jasper/software
JASPER_INSTALL_STAGING = YES
JASPER_LICENSE = JasPer License Version 2.0
JASPER_LICENSE_FILES = LICENSE
JASPER_SUPPORTS_IN_SOURCE_BUILD = NO
JASPER_CONF_OPTS = \
	-DCMAKE_DISABLE_FIND_PACKAGE_DOXYGEN=TRUE \
	-DCMAKE_DISABLE_FIND_PACKAGE_LATEX=TRUE

ifeq ($(BR2_STATIC_LIBS),y)
JASPER_CONF_OPTS += -DJAS_ENABLE_SHARED=OFF
endif

ifeq ($(BR2_PACKAGE_JPEG),y)
JASPER_CONF_OPTS += -DJAS_ENABLE_LIBJPEG=ON
JASPER_DEPENDENCIES += jpeg
else
JASPER_CONF_OPTS += -DJAS_ENABLE_LIBJPEG=OFF
endif

$(eval $(cmake-package))
