################################################################################
#
# bwm-ng
#
################################################################################

BWM_NG_VERSION = 0.6.1
BWM_NG_SITE = http://www.gropp.org/bwm-ng
BWM_NG_CONF_OPTS = --with-procnetdev --with-diskstats
BWM_NG_LICENSE = GPLv2
BWM_NG_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_NCURSES),y)
BWM_NG_CONF_OPTS += --with-ncurses
BWM_NG_DEPENDENCIES += ncurses
endif

$(eval $(autotools-package))
