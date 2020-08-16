################################################################################
#
# glog
#
################################################################################

GLOG_VERSION = 0.4.0
GLOG_SITE = $(call github,google,glog,v$(GLOG_VERSION))
GLOG_INSTALL_STAGING = YES
GLOG_LICENSE = BSD-3-Clause
GLOG_LICENSE_FILES = COPYING
GLOG_CONF_OPTS = \
	$(if $(BR2_TOOLCHAIN_HAS_THREADS),-DWITH_THREADS=ON, -DWITH_THREADS=OFF)

ifeq ($(BR2_PACKAGE_GFLAGS),y)
GLOG_DEPENDENCIES = gflags
GLOG_CONF_OPTS += -DWITH_GFLAGS=ON
else
GLOG_CONF_OPTS += -DWITH_GFLAGS=OFF
endif

$(eval $(cmake-package))
