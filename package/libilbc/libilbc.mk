################################################################################
#
# libilbc
#
################################################################################

LIBILBC_VERSION = 829b08c7902ceb87a261279fabb36b6d523c6e07
LIBILBC_SITE = https://freeswitch.org/stash/scm/sd/libilbc.git
LIBILBC_SITE_METHOD = git
LIBILBC_LICENSE = Global IP Sound iLBC Public License v2.0
LIBILBC_LICENSE_FILES = gips_iLBClicense.pdf
LIBILBC_AUTORECONF = YES
LIBILBC_INSTALL_STAGING = YES

$(eval $(autotools-package))
