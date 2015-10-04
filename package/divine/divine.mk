################################################################################
#
# divine
#
################################################################################

# tagged version 1.6.3, tarball is missing files
DIVINE_VERSION = 83cafc257a42b9465cd9d6185bf66b8c1b7ed704
DIVINE_SITE = git://git.directfb.org/git/directfb/extras/DiVine.git
DIVINE_LICENSE = LGPLv2.1+
DIVINE_LICENSE_FILES = COPYING
DIVINE_INSTALL_STAGING = YES
DIVINE_DEPENDENCIES = directfb
DIVINE_CONFIG_SCRIPTS = divine-config

# package has no configure script so we have to generate it
DIVINE_AUTORECONF = YES

$(eval $(autotools-package))
