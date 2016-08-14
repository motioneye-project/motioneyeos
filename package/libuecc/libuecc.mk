################################################################################
#
# libuecc
#
################################################################################

LIBUECC_VERSION = 7
LIBUECC_SITE = https://projects.universe-factory.net/attachments/download/85
LIBUECC_SOURCE = libuecc-$(LIBUECC_VERSION).tar.xz
LIBUECC_LICENSE = BSD-2c
LIBUECC_LICENSE_FILES = COPYRIGHT
LIBUECC_INSTALL_STAGING = YES

$(eval $(cmake-package))
