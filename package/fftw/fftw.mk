################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3.3
FFTW_SITE = http://www.fftw.org
FFTW_INSTALL_STAGING = YES
FFTW_LICENSE = GPLv2+
FFTW_LICENSE_FILES = COPYING

$(eval $(autotools-package))
