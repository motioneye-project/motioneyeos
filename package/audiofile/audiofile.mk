################################################################################
#
# audiofile
#
################################################################################

AUDIOFILE_VERSION = 0.3.6
AUDIOFILE_SITE = http://audiofile.68k.org
AUDIOFILE_INSTALL_STAGING = YES
AUDIOFILE_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
AUDIOFILE_CONF_OPT = --disable-examples --disable-docs
AUDIOFILE_DEPENDENCIES = host-pkgconf
# configure is outdated and has old bugs because of it
AUDIOFILE_AUTORECONF = YES
AUDIOFILE_LICENSE = GPLv2+ LGPLv2.1+
AUDIOFILE_LICENSE_FILES = COPYING COPYING.GPL

ifeq ($(BR2_PACKAGE_FLAC),y)
AUDIOFILE_DEPENDENCIES += flac
AUDIOFILE_CONF_OPT += --enable-flac
else
AUDIOFILE_CONF_OPT += --disable-flac
endif

$(eval $(autotools-package))
