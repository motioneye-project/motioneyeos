################################################################################
#
# pixman
#
################################################################################
PIXMAN_VERSION = 0.25.2
PIXMAN_SITE = http://xorg.freedesktop.org/releases/individual/lib
PIXMAN_INSTALL_STAGING = YES
PIXMAN_DEPENDENCIES = host-pkg-config
# don't build gtk based demos
PIXMAN_CONF_OPT = --disable-gtk

# disable iwmmxt support for CPU's that don't have
# this feature
ifneq ($(BR2_iwmmxt),y)
PIXMAN_CONF_OPT += --disable-arm-iwmmxt
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
