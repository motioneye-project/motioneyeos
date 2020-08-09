################################################################################
#
# nginx-dav-ext
#
################################################################################

NGINX_DAV_EXT_VERSION = 0.1.0
NGINX_DAV_EXT_SITE = $(call github,arut,nginx-dav-ext-module,v$(NGINX_DAV_EXT_VERSION))
NGINX_DAV_EXT_LICENSE = BSD-2-Clause
NGINX_DAV_EXT_LICENSE_FILES = LICENSE
NGINX_DAV_EXT_DEPENDENCIES = expat

$(eval $(generic-package))
