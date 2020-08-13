################################################################################
#
# belr
#
################################################################################

BELR_VERSION = 4.3.1
BELR_SITE = https://gitlab.linphone.org/BC/public/belr/-/archive/$(BELR_VERSION)
BELR_LICENSE = GPL-3.0+
BELR_LICENSE_FILES = LICENSE.txt
BELR_INSTALL_STAGING = YES
BELR_DEPENDENCIES = bctoolbox
BELR_CONF_OPTS = \
	-DENABLE_STRICT=OFF \
	-DENABLE_TESTS=OFF \
	-DENABLE_TOOLS=OFF

ifeq ($(BR2_STATIC_LIBS),y)
BELR_CONF_OPTS += -DENABLE_SHARED=OFF -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BELR_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_LIBS),y)
BELR_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
