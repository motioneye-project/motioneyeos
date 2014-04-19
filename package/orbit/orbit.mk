################################################################################
#
# orbit
#
################################################################################

ORBIT_VERSION_UPSTREAM = 2.2.1
ORBIT_VERSION = $(ORBIT_VERSION_UPSTREAM)-1
ORBIT_SUBDIR  = orbit
ORBIT_LICENSE = MIT
ORBIT_LICENSE_FILES = $(ORBIT_SUBDIR)/doc/us/license.md

$(eval $(luarocks-package))
