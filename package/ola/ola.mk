################################################################################
#
# ola
#
################################################################################

OLA_VERSION = 0.8.32
OLA_SITE = https://open-lighting.googlecode.com/files

OLA_LICENSE = LGPLv2.1+ (libola, libolacommon, Python bindings), GPLv2+ (libolaserver, olad, Python examples and tests)
OLA_LICENSE_FILES = LICENCE GPL LGPL
OLA_INSTALL_STAGING = YES

# util-linux provides uuid lib
OLA_DEPENDENCIES = protobuf util-linux host-bison host-flex

OLA_CONF_OPT = \
	--disable-gcov \
	--disable-tcmalloc \
	--disable-unittests \
	--disable-root-check \
	--disable-java-libs \
	--disable-fatal-warnings

# sets where to find python libs built for target and required by ola
OLA_CONF_ENV = PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
OLA_MAKE_ENV = PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages

## OLA Bindings and Interface selections

ifeq ($(BR2_PACKAGE_OLA_WEB),y)
OLA_CONF_OPT += --enable-http
OLA_DEPENDENCIES += libmicrohttpd
else
OLA_CONF_OPT += --disable-http
endif

ifeq ($(BR2_PACKAGE_OLA_SLP),y)
OLA_CONF_OPT += --enable-slp
else
OLA_CONF_OPT += --disable-slp
endif

ifeq ($(BR2_PACKAGE_OLA_PYTHON_BINDINGS),y)
OLA_CONF_OPT += --enable-python-libs
OLA_DEPENDENCIES += python python-protobuf
else
OLA_CONF_OPT += --disable-python-libs
endif

## OLA Examples and Tests

ifeq ($(BR2_PACKAGE_OLA_EXAMPLES),y)
OLA_CONF_OPT += --enable-examples
OLA_DEPENDENCIES += ncurses
else
OLA_CONF_OPT += --disable-examples
endif

ifeq ($(BR2_PACKAGE_OLA_RDM_TESTS),y)
OLA_CONF_OPT += --enable-rdm-tests
else
OLA_CONF_OPT += --disable-rdm-tests
endif

## OLA Plugin selections

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_E131),y)
OLA_CONF_OPT += --enable-e131
else
OLA_CONF_OPT += --disable-e131
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_ARTNET),y)
OLA_CONF_OPT += --enable-artnet
else
OLA_CONF_OPT += --disable-artnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_OPENDMX),y)
OLA_CONF_OPT += --enable-opendmx
else
OLA_CONF_OPT += --disable-opendmx
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_DUMMY),y)
OLA_CONF_OPT += --enable-dummy
else
OLA_CONF_OPT += --disable-dummy
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_ESPNET),y)
OLA_CONF_OPT += --enable-espnet
else
OLA_CONF_OPT += --disable-espnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_KINET),y)
OLA_CONF_OPT += --enable-kinet
else
OLA_CONF_OPT += --disable-kinet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_OSC),y)
OLA_CONF_OPT += --enable-osc
OLA_DEPENDENCIES += liblo
else
OLA_CONF_OPT += --disable-osc
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_MILINT),y)
OLA_CONF_OPT += --enable-milinst
else
OLA_CONF_OPT += --disable-milinst
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_PATHPORT),y)
OLA_CONF_OPT += --enable-pathport
else
OLA_CONF_OPT += --disable-pathport
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_SANDNET),y)
OLA_CONF_OPT += --enable-sandnet
else
OLA_CONF_OPT += --disable-sandnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_SHOWNET),y)
OLA_CONF_OPT += --enable-shownet
else
OLA_CONF_OPT += --disable-shownet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_STAGEPROFI),y)
OLA_CONF_OPT += --enable-stageprofi --enable-libusb
else
OLA_CONF_OPT += --disable-stageprofi
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_USBPRO),y)
OLA_CONF_OPT += --enable-usbpro --enable-libusb
else
OLA_CONF_OPT += --disable-usbpro
endif

$(eval $(autotools-package))
