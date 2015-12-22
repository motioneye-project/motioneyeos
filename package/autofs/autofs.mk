################################################################################
#
# autofs
#
################################################################################

AUTOFS_VERSION = 5.1.1
AUTOFS_SOURCE = autofs-$(AUTOFS_VERSION).tar.xz
AUTOFS_SITE = $(BR2_KERNEL_MIRROR)/linux/daemons/autofs/v5
AUTOFS_LICENSE = GPLv2+
AUTOFS_LICENSE_FILES = COPYING COPYRIGHT
AUTOFS_DEPENDENCIES = host-flex host-bison

AUTOFS_CONF_OPTS = \
	--disable-mount-locking \
	--enable-ignore-busy \
	--without-openldap \
	--without-sasl

AUTOFS_MAKE_ENV = DONTSTRIP=1

$(eval $(autotools-package))
