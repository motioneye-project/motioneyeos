################################################################################
#
# sedutil
#
################################################################################

SEDUTIL_VERSION = 1.15.1
SEDUTIL_SITE = $(call github,Drive-Trust-Alliance,sedutil,$(SEDUTIL_VERSION))
SEDUTIL_LICENSE = GPL-3.0+
SEDUTIL_LICENSE_FILES = Common/LICENSE.txt
# Fetched from Github with no configure script
SEDUTIL_AUTORECONF = YES

# Calls git to figure out version info
define SEDUTIL_SET_VERSION
	echo '#define GIT_VERSION "$(SEDUTIL_VERSION)"' > $(@D)/linux/Version.h
endef
SEDUTIL_POST_CONFIGURE_HOOKS += SEDUTIL_SET_VERSION

$(eval $(autotools-package))
