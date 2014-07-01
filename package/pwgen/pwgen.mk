################################################################################
#
# pwgen
#
################################################################################

PWGEN_VERSION = 2.06
PWGEN_SITE = http://downloads.sourceforge.net/project/pwgen/pwgen/$(PWGEN_VERSION)
PWGEN_LICENSE = GPLv2
PWGEN_LICENSE_FILES = debian/copyright

$(eval $(autotools-package))
$(eval $(host-autotools-package))
