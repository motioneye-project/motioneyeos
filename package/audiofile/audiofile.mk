################################################################################
#
# audiofile
#
################################################################################

AUDIOFILE_VERSION = 0.3.6
AUDIOFILE_SITE = http://audiofile.68k.org
AUDIOFILE_INSTALL_STAGING = YES
AUDIOFILE_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
AUDIOFILE_CONF_OPTS = --disable-examples
AUDIOFILE_DEPENDENCIES = host-pkgconf
# configure is outdated and has old bugs because of it
AUDIOFILE_AUTORECONF = YES
AUDIOFILE_LICENSE = GPL-2.0+, LGPL-2.1+
AUDIOFILE_LICENSE_FILES = COPYING COPYING.GPL

# 0003-Always-check-the-number-of-coefficients.patch
AUDIOFILE_IGNORE_CVES += \
	CVE-2017-6827 CVE-2017-6828 CVE-2017-6832 \
	CVE-2017-6833 CVE-2017-6835 CVE-2017-6837
# 0004-clamp-index-values-to-fix-index-overflow-in-IMA.cpp.patch
AUDIOFILE_IGNORE_CVES += CVE-2017-6829
# 0005-Check-for-multiplication-overflow-in-sfconvert.patch
AUDIOFILE_IGNORE_CVES += \
	CVE-2017-6830 CVE-2017-6834 CVE-2017-6836 CVE-2017-6838
# 0006-Actually-fail-when-error-occurs-in-parseFormat.patch
AUDIOFILE_IGNORE_CVES += CVE-2017-6831
# 0007-Check-for-multiplication-overflow-in-MSADPCM-decodeS.patch
AUDIOFILE_IGNORE_CVES += CVE-2017-6839
# 0008-CVE-2015-7747.patch
AUDIOFILE_IGNORE_CVES += CVE-2015-7747

ifeq ($(BR2_PACKAGE_FLAC),y)
AUDIOFILE_DEPENDENCIES += flac
AUDIOFILE_CONF_OPTS += --enable-flac
else
AUDIOFILE_CONF_OPTS += --disable-flac
endif

$(eval $(autotools-package))
