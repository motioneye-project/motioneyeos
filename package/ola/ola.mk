################################################################################
#
# ola
#
################################################################################

OLA_VERSION = 0.9.6
OLA_SITE = $(call github,OpenLightingProject,ola,$(OLA_VERSION))

OLA_LICENSE = LGPLv2.1+ (libola, libolacommon, Python bindings), GPLv2+ (libolaserver, olad, Python examples and tests)
OLA_LICENSE_FILES = LICENCE GPL LGPL
OLA_INSTALL_STAGING = YES
OLA_AUTORECONF = YES

# util-linux provides uuid lib
OLA_DEPENDENCIES = protobuf util-linux host-bison host-flex host-ola

OLA_CONF_OPTS = \
	ac_cv_have_pymod_google_protobuf=yes \
	--disable-gcov \
	--disable-tcmalloc \
	--disable-unittests \
	--disable-root-check \
	--disable-java-libs \
	--disable-fatal-warnings \
	--with-ola-protoc-plugin=$(HOST_DIR)/usr/bin/ola_protoc_plugin

HOST_OLA_DEPENDENCIES = host-util-linux host-protobuf

# When building the host part, disable as much as possible to speed up
# the configure step and avoid missing host dependencies.
HOST_OLA_CONF_OPTS = \
	--disable-all-plugins \
	--disable-slp \
	--disable-osc \
	--disable-uart \
	--disable-libusb \
	--disable-libftdi \
	--disable-http  \
	--disable-examples \
	--disable-unittests \
	--disable-doxygen-html \
	--disable-doxygen-doc

# On the host side, we only need ola_protoc_plugin, so build and install this
# only.
HOST_OLA_MAKE_OPTS = protoc/ola_protoc_plugin
define HOST_OLA_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/protoc/ola_protoc_plugin $(HOST_DIR)/usr/bin/ola_protoc_plugin
endef

# sets where to find python libs built for target and required by ola
OLA_CONF_ENV = PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
OLA_MAKE_ENV = PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages

## OLA Bindings and Interface selections

ifeq ($(BR2_PACKAGE_OLA_WEB),y)
OLA_CONF_OPTS += --enable-http
OLA_DEPENDENCIES += libmicrohttpd
else
OLA_CONF_OPTS += --disable-http
endif

ifeq ($(BR2_PACKAGE_OLA_SLP),y)
OLA_CONF_OPTS += --enable-slp
else
OLA_CONF_OPTS += --disable-slp
endif

ifeq ($(BR2_PACKAGE_OLA_PYTHON_BINDINGS),y)
OLA_CONF_OPTS += --enable-python-libs
OLA_DEPENDENCIES += python python-protobuf
else
OLA_CONF_OPTS += --disable-python-libs
endif

## OLA Examples and Tests

ifeq ($(BR2_PACKAGE_OLA_EXAMPLES),y)
OLA_CONF_OPTS += --enable-examples
OLA_DEPENDENCIES += ncurses
else
OLA_CONF_OPTS += --disable-examples
endif

ifeq ($(BR2_PACKAGE_OLA_RDM_TESTS),y)
OLA_CONF_OPTS += --enable-rdm-tests
else
OLA_CONF_OPTS += --disable-rdm-tests
endif

## OLA Plugin selections

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_E131),y)
OLA_CONF_OPTS += --enable-e131
else
OLA_CONF_OPTS += --disable-e131
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_ARTNET),y)
OLA_CONF_OPTS += --enable-artnet
else
OLA_CONF_OPTS += --disable-artnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_OPENDMX),y)
OLA_CONF_OPTS += --enable-opendmx
else
OLA_CONF_OPTS += --disable-opendmx
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_DUMMY),y)
OLA_CONF_OPTS += --enable-dummy
else
OLA_CONF_OPTS += --disable-dummy
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_ESPNET),y)
OLA_CONF_OPTS += --enable-espnet
else
OLA_CONF_OPTS += --disable-espnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_KINET),y)
OLA_CONF_OPTS += --enable-kinet
else
OLA_CONF_OPTS += --disable-kinet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_OSC),y)
OLA_CONF_OPTS += --enable-osc
OLA_DEPENDENCIES += liblo
else
OLA_CONF_OPTS += --disable-osc
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_MILINT),y)
OLA_CONF_OPTS += --enable-milinst
else
OLA_CONF_OPTS += --disable-milinst
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_PATHPORT),y)
OLA_CONF_OPTS += --enable-pathport
else
OLA_CONF_OPTS += --disable-pathport
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_SANDNET),y)
OLA_CONF_OPTS += --enable-sandnet
else
OLA_CONF_OPTS += --disable-sandnet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_SHOWNET),y)
OLA_CONF_OPTS += --enable-shownet
else
OLA_CONF_OPTS += --disable-shownet
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_STAGEPROFI),y)
OLA_CONF_OPTS += --enable-stageprofi --enable-libusb
else
OLA_CONF_OPTS += --disable-stageprofi
endif

ifeq ($(BR2_PACKAGE_OLA_PLUGIN_USBPRO),y)
OLA_CONF_OPTS += --enable-usbpro --enable-libusb
else
OLA_CONF_OPTS += --disable-usbpro
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
