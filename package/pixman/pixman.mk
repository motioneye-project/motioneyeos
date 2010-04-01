################################################################################
#
# pixman
#
################################################################################
PIXMAN_VERSION = 0.17.6
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = http://cairographics.org/releases/
PIXMAN_AUTORECONF = NO
PIXMAN_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,pixman))
$(eval $(call AUTOTARGETS,package,pixman,host))
