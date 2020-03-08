################################################################################
#
# gr-osmosdr
#
################################################################################

GR_OSMOSDR_VERSION = 46698a67e7e06419eefaf45c95129c0c12669045
GR_OSMOSDR_SITE = $(call github,osmocom,gr-osmosdr,$(GR_OSMOSDR_VERSION))
GR_OSMOSDR_LICENSE = GPL-3.0+
GR_OSMOSDR_LICENSE_FILES = COPYING

# gr-osmosdr prevents doing an in-source-tree build
GR_OSMOSDR_SUPPORTS_IN_SOURCE_BUILD = NO

GR_OSMOSDR_DEPENDENCIES = gnuradio host-python-cheetah

GR_OSMOSDR_CONF_OPTS = \
	-DENABLE_DEFAULT=OFF \
	-DENABLE_DOXYGEN=OFF

# For third-party blocks, the gr-osmosdr libraries are mandatory at
# compile time.
GR_OSMOSDR_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_GR_OSMOSDR_PYTHON),y)
GR_OSMOSDR_CONF_OPTS += -DENABLE_PYTHON=ON
GR_OSMOSDR_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON3),python3,python)
else
GR_OSMOSDR_CONF_OPTS += -DENABLE_PYTHON=OFF
endif

ifeq ($(BR2_PACKAGE_GR_OSMOSDR_IQFILE),y)
GR_OSMOSDR_CONF_OPTS += -DENABLE_FILE=ON
else
GR_OSMOSDR_CONF_OPTS += -DENABLE_FILE=OFF
endif

ifeq ($(BR2_PACKAGE_GR_OSMOSDR_RTLSDR),y)
GR_OSMOSDR_CONF_OPTS += -DENABLE_RTL=ON
GR_OSMOSDR_DEPENDENCIES += librtlsdr
else
GR_OSMOSDR_CONF_OPTS += -DENABLE_RTL=OFF
endif

ifeq ($(BR2_PACKAGE_GR_OSMOSDR_RTLSDR_TCP),y)
GR_OSMOSDR_CONF_OPTS += -DENABLE_RTL_TCP=ON
else
GR_OSMOSDR_CONF_OPTS += -DENABLE_RTL_TCP=OFF
endif

ifeq ($(BR2_PACKAGE_GR_OSMOSDR_RFSPACE),y)
GR_OSMOSDR_CONF_OPTS += -DENABLE_RFSPACE=ON
else
GR_OSMOSDR_CONF_OPTS += -DENABLE_RFSPACE=OFF
endif

$(eval $(cmake-package))
