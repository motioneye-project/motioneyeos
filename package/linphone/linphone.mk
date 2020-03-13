################################################################################
#
# linphone
#
################################################################################

LINPHONE_VERSION = 4.3.1
LINPHONE_SITE = \
	https://gitlab.linphone.org/BC/public/liblinphone/-/archive/$(LINPHONE_VERSION)
LINPHONE_CONF_OPTS = \
	-DENABLE_ADVANCED_IM=OFF \
	-DENABLE_CXX_WRAPPER=OFF \
	-DENABLE_DB_STORAGE=OFF \
	-DENABLE_LIME=OFF \
	-DENABLE_LIME_X3DH=OFF \
	-DENABLE_STRICT=OFF \
	-DENABLE_TOOLS=OFF \
	-DENABLE_TUTORIALS=OFF \
	-DENABLE_UNIT_TESTS=OFF \
	-DENABLE_VCARD=OFF \
	-DENABLE_VIDEO=OFF
LINPHONE_INSTALL_STAGING = YES
LINPHONE_DEPENDENCIES = \
	belle-sip \
	belr \
	libxml2 \
	mediastreamer \
	sqlite \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
LINPHONE_LICENSE = GPL-3.0+
LINPHONE_LICENSE_FILES = LICENSE.txt

ifeq ($(BR2_STATIC_LIBS),y)
LINPHONE_CONF_OPTS += -DENABLE_STATIC=ON -DENABLE_SHARED=OFF
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LINPHONE_CONF_OPTS += -DENABLE_STATIC=ON -DENABLE_SHARED=ON
else ifeq ($(BR2_SHARED_LIBS),y)
LINPHONE_CONF_OPTS += -DENABLE_STATIC=OFF -DENABLE_SHARED=ON
endif

$(eval $(cmake-package))
