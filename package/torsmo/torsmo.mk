#############################################################
#
# torsmo
#
#############################################################
TORSMO_VERSION = 0.18
TORSMO_SOURCE = torsmo-$(TORSMO_VERSION).tar.gz
TORSMO_SITE = http://avr32linux.org/twiki/pub/Main/Torsmo

# help2man doesn't work when cross compiling
TORSMO_CONF_ENV = ac_cv_path_HELP2MAN=''
TORSMO_CONF_OPT = --x-includes="-I$(STAGING_DIR)/usr/include/X11" --x-libraries="-I$(STAGING_DIR)/usr/lib" --with-x

TORSMO_DEPENDENCIES = xserver_xorg-server

$(eval $(autotools-package))

