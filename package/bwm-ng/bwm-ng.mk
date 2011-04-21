#############################################################
#
# bwm-ng
#
#############################################################

BWM_NG_VERSION = 0.6
BWM_NG_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/bwmng/bwmng/$(BWM_NG_VERSION)/
BWM_NG_CONF_OPT = --with-procnetdev --with-diskstats

ifeq ($(BR2_PACKAGE_NCURSES),y)
BWM_NG_CONF_OPT += --with-ncurses
BWM_NG_DEPENDENCIES += ncurses
endif

$(eval $(call AUTOTARGETS,package,bwm-ng))
