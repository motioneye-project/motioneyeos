################################################################################
#
# alsamixergui
#
################################################################################

ALSAMIXERGUI_VERSION = 0.9.0rc2-1
ALSAMIXERGUI_SOURCE = alsamixergui_$(ALSAMIXERGUI_VERSION).orig.tar.gz
ALSAMIXERGUI_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/a/alsamixergui
ALSAMIXERGUI_AUTORECONF = YES

ALSAMIXERGUI_CONF_ENV = \
	ac_cv_lib_fltk_numericsort=yes \
	ac_cv_lib_fltk_fl_numericsort=yes \
	ac_cv_lib_asound_snd_ctl_open=yes

ALSAMIXERGUI_DEPENDENCIES = fltk alsa-lib

$(eval $(autotools-package))
