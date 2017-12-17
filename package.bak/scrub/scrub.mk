################################################################################
#
# scrub
#
################################################################################

SCRUB_VERSION = 2.6.1
SCRUB_SITE = $(call github,chaos,scrub,$(SCRUB_VERSION))
SCRUB_LICENSE = GPLv2+
SCRUB_LICENSE_FILES = COPYING DISCLAIMER
SCRUB_PATCH = https://github.com/chaos/scrub/commit/11d30916dd9c11a26c7c8a0f6db9e6ebca301594.patch

# Fetching from the git repo, no configure/Makefile generated, and patching
# configure.ac
SCRUB_AUTORECONF = YES

$(eval $(autotools-package))
