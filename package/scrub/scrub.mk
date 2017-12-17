################################################################################
#
# scrub
#
################################################################################

SCRUB_VERSION = 2.6.1
SCRUB_SITE = $(call github,chaos,scrub,$(SCRUB_VERSION))
SCRUB_LICENSE = GPL-2.0+
SCRUB_LICENSE_FILES = COPYING DISCLAIMER

# Fetching from the git repo, no configure/Makefile generated, and patching
# configure.ac
SCRUB_AUTORECONF = YES

$(eval $(autotools-package))
