################################################################################
#
# orbit
#
################################################################################

ORBIT_VERSION = 2.2.4-1
ORBIT_SUBDIR = orbit
ORBIT_LICENSE = MIT
ORBIT_LICENSE_FILES = \
	$(ORBIT_SUBDIR)/doc/us/license.html \
	$(ORBIT_SUBDIR)/doc/us/license.md

$(eval $(luarocks-package))
