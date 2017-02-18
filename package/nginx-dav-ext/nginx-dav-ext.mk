################################################################################
#
# nginx-dav-ext
#
################################################################################

NGINX_DAV_EXT_VERSION = v0.0.3
NGINX_DAV_EXT_SITE = $(call github,arut,nginx-dav-ext-module,$(NGINX_DAV_EXT_VERSION))
NGINX_DAV_EXT_LICENSE = BSD-2c
NGINX_DAV_EXT_LICENSE_FILES = ngx_http_dav_ext_module.c
NGINX_DAV_EXT_DEPENDENCIES = expat

$(eval $(generic-package))
