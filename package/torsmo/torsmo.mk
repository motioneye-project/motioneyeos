#############################################################
#
# torsmo
#
#############################################################
TORSMO_VERSION = 0.18
TORSMO_SOURCE = torsmo-$(TORSMO_VERSION).tar.gz
TORSMO_SITE = http://avr32linux.org/twiki/pub/Main/Torsmo
TORSMO_AUTORECONF = NO
TORSMO_INSTALL_STAGING = NO
TORSMO_INSTALL_TARGET = YES

TORSMO_CONF_OPT = --x-includes="-I$(STAGING_DIR)/usr/include/X11" --x-libraries="-I$(STAGING_DIR)/usr/lib" --with-x

TORSMO_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,torsmo))

