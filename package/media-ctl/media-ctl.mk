################################################################################
#
# media-ctl
#
################################################################################

MEDIA_CTL_VERSION = 87f58c2ed885d636229f7209fde883058433a1ce
MEDIA_CTL_SITE = git://git.ideasonboard.org/media-ctl.git
MEDIA_CTL_INSTALL_STAGING = YES
MEDIA_CTL_LICENSE = LGPLv2.1+
MEDIA_CTL_LICENSE_FILES = COPYING.LIB

MEDIA_CTL_AUTORECONF = YES
MEDIA_CTL_CONF_OPTS = --with-kernel-headers=$(STAGING_DIR)/usr/include
MEDIA_CTL_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
