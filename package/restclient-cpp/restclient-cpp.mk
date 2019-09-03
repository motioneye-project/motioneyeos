################################################################################
#
# restclient-cpp
#
################################################################################

RESTCLIENT_CPP_VERSION = 0.5.1
RESTCLIENT_CPP_SITE =  $(call github,mrtazz,restclient-cpp,$(RESTCLIENT_CPP_VERSION))
RESTCLIENT_CPP_LICENSE = MIT
RESTCLIENT_CPP_LICENSE_FILES = LICENSE
RESTCLIENT_CPP_INSTALL_STAGING = YES

# Source from github, no configure script provided
RESTCLIENT_CPP_AUTORECONF = YES

RESTCLIENT_CPP_DEPENDENCIES = libcurl

$(eval $(autotools-package))
