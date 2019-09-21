################################################################################
#
# gengetopt
#
################################################################################

GENGETOPT_VERSION = 2.23
GENGETOPT_SOURCE = gengetopt-$(GENGETOPT_VERSION).tar.xz
GENGETOPT_SITE = $(BR2_GNU_MIRROR)/gengetopt
GENGETOPT_LICENSE = GPL-3.0+
GENGETOPT_LICENSE_FILES = COPYING LICENSE

$(eval $(host-autotools-package))
