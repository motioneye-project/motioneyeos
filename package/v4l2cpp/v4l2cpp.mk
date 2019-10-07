#############################################################
#
# v4l2cpp
#
#############################################################

V4L2CPP_VERSION=021d887dc531bcf74c766cb413f87e8fc92579e3
V4L2CPP_SITE = https://github.com/jasaw/libv4l2cpp.git
V4L2CPP_SITE_METHOD = git
V4L2CPP_LICENSE = UNLICENSE
V4L2CPP_LICENSE_FILES = LICENSE
V4L2CPP_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_STATIC_LIBS),y)
V4L2CPP_CONFIG_TARGET = linux
V4L2CPP_LIBRARY_LINK = $(TARGET_AR) cr
else
V4L2CPP_CONFIG_TARGET = linux-with-shared-libraries
V4L2CPP_LIBRARY_LINK = $(TARGET_CC) -o
V4L2CPP_CFLAGS += -fPIC
endif

ifndef ($(BR2_ENABLE_LOCALE),y)
V4L2CPP_CFLAGS += -DLOCALE_NOT_USED
endif

define V4L2CPP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" EXTRA_CXXFLAGS="$(V4L2CPP_CFLAGS)" -C $(@D) all
endef

define V4L2CPP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="$(STAGING_DIR)/usr" -C $(@D) install
	$(INSTALL) -D -m 0755 $(@D)/libv4l2wrapper.so $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
