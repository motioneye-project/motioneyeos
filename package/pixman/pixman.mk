################################################################################
#
# pixman
#
################################################################################
PIXMAN_VERSION = 0.24.2
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = http://cairographics.org/releases/
PIXMAN_INSTALL_STAGING = YES
PIXMAN_DEPENDENCIES = host-pkg-config
# don't build gtk based demos
PIXMAN_CONF_OPT = --disable-gtk

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
