################################################################################
#
# pwgen
#
################################################################################

PWGEN_VERSION = 2.07
PWGEN_SITE = http://downloads.sourceforge.net/project/pwgen/pwgen/$(PWGEN_VERSION)
PWGEN_LICENSE = GPL-2.0
PWGEN_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
$(eval $(host-autotools-package))
