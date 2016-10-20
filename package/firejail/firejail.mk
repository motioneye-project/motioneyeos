################################################################################
#
# firejail
#
################################################################################

FIREJAIL_VERSION = 0.9.42
FIREJAIL_SITE = http://download.sourceforge.net/firejail
FIREJAIL_SOURCE = firejail-$(FIREJAIL_VERSION).tar.xz
FIREJAIL_LICENSE = GPLv2
FIREJAIL_LICENSE_FILES = COPYING
FIREJAIL_CONF_OPTS = \
	--enable-bind \
	--enable-busybox-workaround \
	--enable-file-transfer \
	--enable-network \
	--enable-seccomp \
	--enable-userns

define FIREJAIL_PERMISSIONS
	/usr/bin/firejail f 4755 0 0 - - - - -
endef

$(eval $(autotools-package))
