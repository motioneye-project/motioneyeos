#############################################################
#
# bellagio
#
#############################################################
BELLAGIO_VERSION = 0.9.3
BELLAGIO_SOURCE = libomxil-bellagio-$(BELLAGIO_VERSION).tar.gz
BELLAGIO_SITE = http://downloads.sourceforge.net/project/omxil/omxil/Bellagio%20$(BELLAGIO_VERSION)
BELLAGIO_AUTORECONF = YES
BELLAGIO_INSTALL_STAGING = YES

$(eval $(autotools-package))
