################################################################################
#
# gengetopt
#
################################################################################

GENGETOPT_VERSION = 2.22.6
GENGETOPT_SITE = $(BR2_GNU_MIRROR)/gengetopt
GENGETOPT_LICENSE = GPLv3+
GENGETOPT_LICENSE_FILES = COPYING LICENSE

# Parallel build broken
GENGETOPT_MAKE = $(MAKE1)

$(eval $(host-autotools-package))
