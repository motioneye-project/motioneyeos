################################################################################
#
# glog
#
################################################################################

GLOG_VERSION = v0.3.4
GLOG_SITE = $(call github,google,glog,$(GLOG_VERSION))
GLOG_INSTALL_STAGING = YES
GLOG_LICENSE = BSD-3c
GLOG_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GFLAGS),y)
GLOG_DEPENDENCIES = gflags
endif

$(eval $(autotools-package))
