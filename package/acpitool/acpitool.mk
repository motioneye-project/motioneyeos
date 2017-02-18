################################################################################
#
# acpitool
#
################################################################################

ACPITOOL_VERSION = 0.5.1
ACPITOOL_SOURCE = acpitool-$(ACPITOOL_VERSION).tar.bz2
ACPITOOL_SITE = http://downloads.sourceforge.net/sourceforge/acpitool
ACPITOOL_LICENSE = GPLv2+
ACPITOOL_LICENSE_FILES = COPYING

$(eval $(autotools-package))
