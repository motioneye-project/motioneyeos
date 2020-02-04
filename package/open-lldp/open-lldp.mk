################################################################################
#
# open-lldp
#
################################################################################

OPEN_LLDP_VERSION = 036e314bd93602f7388262cc37faf8b626980af1
OPEN_LLDP_SITE = git://open-lldp.org/open-lldp.git
OPEN_LLDP_DEPENDENCIES = readline libnl libconfig host-pkgconf
OPEN_LLDP_LICENSE = GPL-2.0
OPEN_LLDP_LICENSE_FILES = COPYING

# Fetching from git, need to generate configure/Makefile.in
OPEN_LLDP_AUTORECONF = YES

$(eval $(autotools-package))
