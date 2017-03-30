################################################################################
#
# nginx-naxsi
#
################################################################################

NGINX_NAXSI_VERSION = 0.55.3
NGINX_NAXSI_SITE = $(call github,nbs-system,naxsi,$(NGINX_NAXSI_VERSION))
NGINX_NAXSI_LICENSE = GPL-2.0+ with OpenSSL exception
NGINX_NAXSI_LICENSE_FILES = naxsi_src/naxsi_json.c

$(eval $(generic-package))
