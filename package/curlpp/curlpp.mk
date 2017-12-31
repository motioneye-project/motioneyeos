################################################################################
#
# curlpp
#
################################################################################

CURLPP_VERSION = 0.8.1
CURLPP_SITE = https://github.com/jpbarrette/curlpp/archive
CURLPP_SOURCE = v$(CURLPP_VERSION).tar.gz
CURLPP_LICENSE = MIT
CURLPP_LICENSE_FILES = doc/LICENSE
CURLPP_INSTALL_STAGING = YES
CURLPP_DEPENDENCIES = libcurl

$(eval $(cmake-package))
