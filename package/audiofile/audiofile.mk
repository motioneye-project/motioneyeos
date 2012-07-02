#############################################################
#
# audiofile
#
#############################################################

AUDIOFILE_VERSION = 0.3.4
AUDIOFILE_SITE = http://audiofile.68k.org
AUDIOFILE_INSTALL_STAGING = YES
AUDIOFILE_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'

# Useless and needs alsa-lib
define AUDIOFILE_DISABLE_EXAMPLES
	$(SED) 's/examples//' $(@D)/Makefile.in
endef

AUDIOFILE_POST_PATCH_HOOKS += AUDIOFILE_DISABLE_EXAMPLES

$(eval $(autotools-package))
