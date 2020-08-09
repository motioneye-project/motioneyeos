################################################################################
#
# belle-sip
#
################################################################################

BELLE_SIP_VERSION = 4.3.1
BELLE_SIP_SITE = \
	https://gitlab.linphone.org/BC/public/belle-sip/-/archive/$(BELLE_SIP_VERSION)
BELLE_SIP_LICENSE = GPL-3.0+
BELLE_SIP_LICENSE_FILES = LICENSE.txt
BELLE_SIP_INSTALL_STAGING = YES
BELLE_SIP_DEPENDENCIES = \
	bctoolbox \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
BELLE_SIP_CONF_OPTS = \
	-DENABLE_STRICT=OFF \
	-DENABLE_TESTS=OFF

ifeq ($(BR2_PACKAGE_AVAHI_LIBDNSSD_COMPATIBILITY),y)
BELLE_SIP_CONF_OPTS += -DENABLE_MDNS=ON
BELLE_SIP_DEPENDENCIES += avahi
else
BELLE_SIP_CONF_OPTS += -DENABLE_MDNS=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
BELLE_SIP_CONF_OPTS += -DENABLE_SHARED=OFF -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BELLE_SIP_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_LIBS),y)
BELLE_SIP_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
