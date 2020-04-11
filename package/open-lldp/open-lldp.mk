################################################################################
#
# open-lldp
#
################################################################################

OPEN_LLDP_VERSION = b71bfb87fefb31c4b1a6a7ae351791c90966c3a8
OPEN_LLDP_SITE = $(call github,intel,openlldp,$(OPEN_LLDP_VERSION))
OPEN_LLDP_DEPENDENCIES = readline libnl libconfig host-pkgconf
OPEN_LLDP_LICENSE = GPL-2.0
OPEN_LLDP_LICENSE_FILES = COPYING

# Fetching from git, need to generate configure/Makefile.in
OPEN_LLDP_AUTORECONF = YES

$(eval $(autotools-package))
