################################################################################
#
# bwm-ng
#
################################################################################

BWM_NG_VERSION = f54b3fad2c80bfe63f920c9b5e7c1d80389c57ef
BWM_NG_SITE = $(call github,vgropp,bwm-ng,$(BWM_NG_VERSION))
BWM_NG_CONF_OPTS = --with-procnetdev --with-diskstats
BWM_NG_LICENSE = GPL-2.0
BWM_NG_LICENSE_FILES = COPYING
BWM_NG_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_NCURSES),y)
BWM_NG_CONF_OPTS += --with-ncurses
BWM_NG_DEPENDENCIES += ncurses
endif

$(eval $(autotools-package))
