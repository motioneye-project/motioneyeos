################################################################################
#
# minicom
#
################################################################################

MINICOM_VERSION = 2.7
MINICOM_SITE = https://alioth.debian.org/frs/download.php/file/3977
MINICOM_LICENSE = GPLv2+
MINICOM_LICENSE_FILES = COPYING

# pkg-config is only used to check for liblockdev, which we don't have
# in BR, so instead of adding host-pkgconf as a dependency, simply make
# sure the host version isn't used so we don't end up with problems if
# people have liblockdev1-dev installed
MINICOM_CONF_ENV = PKG_CONFIG=/bin/false

MINICOM_DEPENDENCIES = ncurses $(if $(BR2_ENABLE_LOCALE),,libiconv)

$(eval $(autotools-package))
