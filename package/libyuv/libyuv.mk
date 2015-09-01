################################################################################
#
# libyuv
#
################################################################################

LIBYUV_VERSION = 1ebf86795cb213a37f06eb1ef3713cff080568ea
# we use the FreeSwitch fork because there is currently no alternative
# for https://chromium.googlesource.com/libyuv/libyuv which will be
# deactivated in 2015.
LIBYUV_SITE = https://freeswitch.org/stash/scm/sd/libyuv.git
LIBYUV_SITE_METHOD = git
LIBYUV_LICENSE = BSD-3c
LIBYUV_LICENSE_FILES = LICENSE
LIBYUV_INSTALL_STAGING = YES
LIBYUV_DEPENDENCIES = $(if $(BR2_PACKAGE_JPEG),jpeg)

$(eval $(cmake-package))
