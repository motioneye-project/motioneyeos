################################################################################
#
# ortp
#
################################################################################

ORTP_VERSION = 0.22.0
ORTP_SITE = http://download.savannah.nongnu.org/releases/linphone/ortp/sources

# ortp is not happy with the libsrtp implementation packaged in
# Buildroot
ORTP_CONF_OPTS = --disable-strict --with-srtp=none
ORTP_INSTALL_STAGING = YES
ORTP_LICENSE = LGPLv2.1+
ORTP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
