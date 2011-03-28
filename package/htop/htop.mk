#############################################################
#
# htop
#
#############################################################

HTOP_VERSION = 0.9
HTOP_SOURCE = htop-$(HTOP_VERSION).tar.gz
HTOP_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/htop/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
HTOP_AUTORECONF = YES

$(eval $(call AUTOTARGETS,package,htop))
