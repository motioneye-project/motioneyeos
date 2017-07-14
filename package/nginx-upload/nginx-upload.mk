################################################################################
#
# nginx-upload
#
################################################################################

NGINX_UPLOAD_VERSION = 70bee48f1811eecd255ed094ce9f0fb560c390c3
NGINX_UPLOAD_SITE = $(call github,vkholodkov,nginx-upload-module,$(NGINX_UPLOAD_VERSION))
NGINX_UPLOAD_LICENSE = BSD-3-Clause
NGINX_UPLOAD_LICENSE_FILES = LICENCE
NGINX_UPLOAD_DEPENDENCIES = openssl

$(eval $(generic-package))
