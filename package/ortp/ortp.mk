################################################################################
#
# ortp
#
################################################################################

ORTP_VERSION = 4.3.1
ORTP_SITE = https://gitlab.linphone.org/BC/public/ortp/-/archive/$(ORTP_VERSION)
ORTP_LICENSE = GPL-3.0+
ORTP_LICENSE_FILES = LICENSE.txt
ORTP_INSTALL_STAGING = YES
ORTP_DEPENDENCIES = bctoolbox
ORTP_CONF_OPTS = \
	-DENABLE_DOC=OFF \
	-DENABLE_STRICT=OFF

ifeq ($(BR2_STATIC_LIBS),y)
ORTP_CONF_OPTS += -DENABLE_STATIC=ON -DENABLE_SHARED=OFF
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
ORTP_CONF_OPTS += -DENABLE_STATIC=ON -DENABLE_SHARED=ON
else ifeq ($(BR2_SHARED_LIBS),y)
ORTP_CONF_OPTS += -DENABLE_STATIC=OFF -DENABLE_SHARED=ON
endif

$(eval $(cmake-package))
