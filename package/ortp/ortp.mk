ORTP_VERSION = 0.20.0
ORTP_SITE = http://download.savannah.nongnu.org/releases/linphone/ortp/sources
ORTP_INSTALL_STAGING = YES

$(eval $(autotools-package))
