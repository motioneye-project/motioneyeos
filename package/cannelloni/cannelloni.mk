################################################################################
#
# cannelloni
#
################################################################################

CANNELLONI_VERSION = v0.5
CANNELLONI_SITE = $(call github,mguentner,cannelloni,$(CANNELLONI_VERSION))
CANNELLONI_LICENSE = GPLv2
CANNELLONI_LICENSE_FILES = gpl-2.0.txt
CANNELLONI_DEPENDENCIES = lksctp-tools

$(eval $(cmake-package))
