################################################################################
#
# odhcp6c
#
################################################################################

ODHCP6C_VERSION = c42e34111e19bd435dc4b5bb3ba81224ea214314
ODHCP6C_SITE = $(call github,sbyx,odhcp6c,$(ODHCP6C_VERSION))
ODHCP6C_LICENSE = GPLv2
ODHCP6C_LICENSE_FILES = COPYING

$(eval $(cmake-package))
