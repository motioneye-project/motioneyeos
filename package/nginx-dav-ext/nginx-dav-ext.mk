################################################################################
#
# nginx-dav-ext
#
################################################################################

NGINX_DAV_EXT_VERSION = v0.1.0
NGINX_DAV_EXT_SITE = $(call github,arut,nginx-dav-ext-module,$(NGINX_DAV_EXT_VERSION))
NGINX_DAV_EXT_LICENSE = BSD-2-Clause
NGINX_DAV_EXT_LICENSE_FILES = LICENSE
NGINX_DAV_EXT_DEPENDENCIES = expat

$(eval $(generic-package))
