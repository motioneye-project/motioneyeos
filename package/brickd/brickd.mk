################################################################################
#
# brickd
#
################################################################################

BRICKD_VERSION = ev3dev-stretch/1.2.1
BRICKD_SITE = https://github.com/ev3dev/brickd
BRICKD_SITE_METHOD = git
BRICKD_GIT_SUBMODULES = YES

BRICKD_LICENSE = GPL-2.0
BRICKD_LICENSE_FILES = LICENSE.txt

BRICKD_INSTALL_STAGING = YES
BRICKD_DEPENDENCIES = host-pkgconf host-vala libglib2 libgudev

define BRICKD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/brickd/S70brickd $(TARGET_DIR)/etc/init.d/S70brickd
endef

$(eval $(cmake-package))
