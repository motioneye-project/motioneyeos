################################################################################
#
# psplash
#
################################################################################

PSPLASH_VERSION = afd4e228c606a9998feae44a3fed4474803240b7
PSPLASH_SITE = git://git.yoctoproject.org/psplash
PSPLASH_LICENSE = GPLv2+
PSPLASH_AUTORECONF = YES

$(eval $(autotools-package))
