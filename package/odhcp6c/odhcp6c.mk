################################################################################
#
# odhcp6c
#
################################################################################

ODHCP6C_VERSION = 8d9b60fb496000988f3633951f2e30380fc2de50
ODHCP6C_SITE = $(call github,sbyx,odhcp6c,$(ODHCP6C_VERSION))
ODHCP6C_LICENSE = GPLv2
ODHCP6C_LICENSE_FILES = COPYING

$(eval $(cmake-package))
