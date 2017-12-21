################################################################################
#
# polkit
#
################################################################################

POLKIT_VERSION = 0.103
POLKIT_SITE = http://www.freedesktop.org/software/polkit/releases
POLKIT_LICENSE = GPL-2.0
POLKIT_LICENSE_FILES = COPYING

POLKIT_INSTALL_STAGING = YES

POLKIT_DEPENDENCIES = libglib2 host-intltool expat

# We could also support --with-authfw=pam
POLKIT_CONF_OPTS = \
	--with-authfw=shadow \
	--with-os-type=unknown \
	--disable-man-pages \
	--disable-examples

$(eval $(autotools-package))
