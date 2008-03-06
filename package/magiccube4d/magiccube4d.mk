#############################################################
#
# magiccube4d
#
#############################################################
MAGICCUBE4D_VERSION = 2_2
MAGICCUBE4D_SOURCE = magiccube4d-src-$(MAGICCUBE4D_VERSION).tar.gz
MAGICCUBE4D_SITE = http://avr32linux.org/twiki/pub/Main/MagicCube4D
MAGICCUBE4D_AUTORECONF = NO
MAGICCUBE4D_INSTALL_STAGING = NO
MAGICCUBE4D_INSTALL_TARGET = YES
MAGICCUBE4D_INSTALL_TARGET_OPT = GAMESDIR=$(TARGET_DIR)/usr/games install

MAGICCUBE4D_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,magiccube4d))

