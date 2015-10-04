################################################################################
#
# lrandom
#
################################################################################

ifeq ($(BR2_PACKAGE_LUA_5_2)$(BR2_PACKAGE_LUA_5_3),y)
LRANDOM_VERSION = 20120430.52-1
else
LRANDOM_VERSION = 20120430.51-1
endif
LRANDOM_SUBDIR = random
LRANDOM_LICENSE = Public domain

$(eval $(luarocks-package))
