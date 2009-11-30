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

ALSAMIXERGUI_CONF_ENV = ac_cv_lib_fltk_numericsort=yes \
			ac_cv_lib_fltk_fl_numericsort=yes \
			ac_cv_lib_asound_snd_ctl_open=yes

ALSAMIXERGUI_DEPENDENCIES = fltk alsa-lib

$(eval $(call AUTOTARGETS,package,alsamixergui))

