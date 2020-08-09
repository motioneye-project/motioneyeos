################################################################################
#
# openfpgaloader
#
################################################################################

OPENFPGALOADER_VERSION = 849e5751e06d4d00f323205d5f02ee01f9f59a61
OPENFPGALOADER_SITE = $(call github,trabucayre,openFPGALoader,$(OPENFPGALOADER_VERSION))
OPENFPGALOADER_LICENSE = AGPL-3.0
OPENFPGALOADER_LICENSE_FILES = LICENSE
OPENFPGALOADER_DEPENDENCIES = libftdi1 udev

ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
OPENFPGALOADER_DEPENDENCIES += argp-standalone
OPENFPGALOADER_CONF_OPTS += -DCMAKE_CXX_STANDARD_LIBRARIES="-largp"
endif

$(eval $(cmake-package))
