################################################################################
#
# libjpeg
#
################################################################################

LIBJPEG_VERSION = 9a
LIBJPEG_SITE = http://www.ijg.org/files/
LIBJPEG_SOURCE = jpegsrc.v$(LIBJPEG_VERSION).tar.gz
LIBJPEG_LICENSE = jpeg-license (BSD-3c-like)
LIBJPEG_LICENSE_FILES = README
LIBJPEG_INSTALL_STAGING = YES

define LIBJPEG_REMOVE_USELESS_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom wrjpgcom)
endef

LIBJPEG_POST_INSTALL_TARGET_HOOKS += LIBJPEG_REMOVE_USELESS_TOOLS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
