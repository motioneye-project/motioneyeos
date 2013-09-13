################################################################################
#
# pcmanfm
#
################################################################################

PCMANFM_VERSION = 0.3.5.9
PCMANFM_SOURCE = pcmanfm-$(PCMANFM_VERSION).tar.gz
PCMANFM_SITE = http://downloads.sourceforge.net/project/pcmanfm/pcmanfm-legacy%20%28Old%200.5%20series%29/PCManFM%20$(PCMANFM_VERSION)
PCMANFM_CONF_OPT = --disable-hal
PCMANFM_DEPENDENCIES = host-pkgconf libgtk2 gamin startup-notification xlib_libX11
PCMANFM_AUTORECONF = YES

$(eval $(autotools-package))
