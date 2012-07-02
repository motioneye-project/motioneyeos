#############################################################
#
# bellagio
#
#############################################################
BELLAGIO_VERSION = 0.9.3
BELLAGIO_SOURCE = libomxil-bellagio-$(BELLAGIO_VERSION).tar.gz
BELLAGIO_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/omxil
BELLAGIO_AUTORECONF = YES
BELLAGIO_INSTALL_STAGING = YES

$(eval $(autotools-package))
