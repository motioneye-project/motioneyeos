################################################################################
#
# collectl
#
################################################################################

COLLECTL_VERSION = 4.3.1
COLLECTL_SOURCE = collectl-$(COLLECTL_VERSION).src.tar.gz
COLLECTL_SITE = http://downloads.sourceforge.net/collectl/collectl
COLLECTL_LICENSE = Artistic or GPL-2.0
COLLECTL_LICENSE_FILES = COPYING ARTISTIC GPL

define COLLECTL_INSTALL_TARGET_CMDS
	(cd $(@D); \
		DESTDIR=$(TARGET_DIR) ./INSTALL)
endef

$(eval $(generic-package))
