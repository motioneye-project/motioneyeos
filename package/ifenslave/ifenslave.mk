################################################################################
#
# ifenslave
#
################################################################################

IFENSLAVE_VERSION = 2.9
IFENSLAVE_SOURCE = ifenslave_$(IFENSLAVE_VERSION).tar.xz
IFENSLAVE_SITE = http://snapshot.debian.org/archive/debian/20170102T091407Z/pool/main/i/ifenslave
IFENSLAVE_LICENSE = GPLv3+
IFENSLAVE_LICENSE_FILES = debian/copyright
IFENSLAVE_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)

# shell script, so nothing to build

define IFENSLAVE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/ifenslave $(TARGET_DIR)/sbin/ifenslave
endef

$(eval $(generic-package))
