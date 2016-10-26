################################################################################
#
# firejail
#
################################################################################

FIREJAIL_VERSION = 0.9.44.8
FIREJAIL_SITE = http://download.sourceforge.net/firejail
FIREJAIL_SOURCE = firejail-$(FIREJAIL_VERSION).tar.xz
FIREJAIL_LICENSE = GPLv2+
FIREJAIL_LICENSE_FILES = COPYING

FIREJAIL_CONF_OPTS = \
	--enable-bind \
	--enable-file-transfer \
	--enable-network \
	--enable-seccomp \
	--enable-userns

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
FIREJAIL_CONF_OPTS += --enable-busybox-workaround
endif

define FIREJAIL_PERMISSIONS
	/usr/bin/firejail f 4755 0 0 - - - - -
endef

$(eval $(autotools-package))
