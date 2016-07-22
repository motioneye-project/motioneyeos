################################################################################
#
# ser2net
#
################################################################################

SER2NET_VERSION = 2.10.1
SER2NET_SITE = http://downloads.sourceforge.net/project/ser2net/ser2net
SER2NET_LICENSE = GPLv2+
SER2NET_LICENSE_FILES = COPYING

define SER2NET_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/ser2net/S50ser2net \
		$(TARGET_DIR)/etc/init.d/S50ser2net
endef

$(eval $(autotools-package))
