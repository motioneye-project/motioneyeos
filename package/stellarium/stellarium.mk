################################################################################
#
# stellarium
#
################################################################################

STELLARIUM_VERSION = 0.19.3
STELLARIUM_SITE = https://github.com/Stellarium/stellarium/releases/download/v$(STELLARIUM_VERSION)
STELLARIUM_LICENSE = GPL-2.0+
STELLARIUM_LICENSE_FILES = COPYING
STELLARIUM_DEPENDENCIES = \
	qt5base \
	qt5location \
	qt5multimedia \
	zlib
STELLARIUM_CONF_OPTS = \
	-DENABLE_MEDIA=ON \
	-DENABLE_NLS=OFF \
	-DUSE_SYSTEM_ZLIB=ON

ifeq ($(BR2_PACKAGE_QT5SCRIPT),y)
STELLARIUM_DEPENDENCIES += qt5script
STELLARIUM_CONF_OPTS += -DENABLE_SCRIPTING=ON
else
STELLARIUM_CONF_OPTS += -DENABLE_SCRIPTING=OFF
endif

ifeq ($(BR2_PACKAGE_QT5SERIALPORT),y)
STELLARIUM_DEPENDENCIES += qt5serialport
ifeq ($(BR2_PACKAGE_GPSD),y)
STELLARIUM_DEPENDENCIES += gpsd
endif
STELLARIUM_CONF_OPTS += \
	-DENABLE_GPS=ON \
	-DUSE_PLUGIN_TELESCOPECONTROL=ON
else
STELLARIUM_CONF_OPTS += \
	-DENABLE_GPS=OFF \
	-DUSE_PLUGIN_TELESCOPECONTROL=OFF
endif

$(eval $(cmake-package))
