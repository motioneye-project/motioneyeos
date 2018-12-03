#############################################################
#
# v4l2cpp
#
#############################################################

V4L2CPP_VERSION=78a8d17631f4f7e21577979ba9412757ec681850
V4L2CPP_SITE = https://github.com/mpromonet/libv4l2cpp.git
V4L2CPP_SITE_METHOD = git
V4L2CPP_LICENSE = UNLICENSE
V4L2CPP_LICENSE_FILES = LICENSE
V4L2CPP_DEPENDENCIES = live555 log4cpp
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
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

$(eval $(generic-package))
