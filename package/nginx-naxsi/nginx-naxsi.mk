################################################################################
#
# nginx-naxsi
#
################################################################################

NGINX_NAXSI_VERSION = 0.54
NGINX_NAXSI_SITE = $(call github,nbs-system,naxsi,$(NGINX_NAXSI_VERSION))
NGINX_NAXSI_LICENSE = GPLv2+ with OpenSSL exception
NGINX_NAXSI_LICENSE_FILES = naxsi_src/naxsi_json.c

$(eval $(generic-package))
