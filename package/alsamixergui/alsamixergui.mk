#############################################################
#
# alsamixergui
#
#############################################################
ALSAMIXERGUI_VERSION = 0.9.0rc2-1
ALSAMIXERGUI_SOURCE = alsamixergui_$(ALSAMIXERGUI_VERSION).orig.tar.gz
ALSAMIXERGUI_SITE = http://snapshot.debian.net/archive/2008/03/19/debian/pool/main/a/alsamixergui
ALSAMIXERGUI_AUTORECONF = YES
ALSAMIXERGUI_INSTALL_STAGING = NO
ALSAMIXERGUI_INSTALL_TARGET = YES

ALSAMIXERGUI_CONF_OPT = LDFLAGS="-L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/avr32-linux-uclibc/lib -lstdc++ -lX11"

ALSAMIXERGUI_DEPENDENCIES = uclibc fltk

$(eval $(call AUTOTARGETS,package,alsamixergui))

