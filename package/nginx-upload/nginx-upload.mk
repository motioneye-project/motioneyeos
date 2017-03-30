################################################################################
#
# nginx-upload
#
################################################################################

NGINX_UPLOAD_VERSION = aba1e3f34c754551f4f49e572bc86863d535609d
NGINX_UPLOAD_SITE = $(call github,vkholodkov,nginx-upload-module,$(NGINX_UPLOAD_VERSION))
NGINX_UPLOAD_LICENSE = BSD-3-Clause
NGINX_UPLOAD_LICENSE_FILES = LICENCE
NGINX_UPLOAD_DEPENDENCIES = openssl

$(eval $(generic-package))
