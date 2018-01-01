################################################################################
#
# ortp
#
################################################################################

ORTP_VERSION = 0.27.0
ORTP_SITE = http://download.savannah.nongnu.org/releases/linphone/ortp/sources

ORTP_CONF_OPTS = --disable-strict
ORTP_INSTALL_STAGING = YES
ORTP_LICENSE = LGPL-2.1+
ORTP_LICENSE_FILES = COPYING
ORTP_DEPENDENCIES = bctoolbox

$(eval $(autotools-package))
