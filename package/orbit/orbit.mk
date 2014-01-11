################################################################################
#
# orbit
#
################################################################################

ORBIT_VERSION_UPSTREAM = 2.2.0
ORBIT_VERSION = $(ORBIT_VERSION_UPSTREAM)-2
ORBIT_SUBDIR  = orbit-$(ORBIT_VERSION_UPSTREAM)
ORBIT_LICENSE = MIT
ORBIT_LICENSE_FILES = $(ORBIT_SUBDIR)/doc/us/license.md

$(eval $(luarocks-package))
