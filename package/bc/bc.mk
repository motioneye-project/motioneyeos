################################################################################
#
# bc
#
################################################################################

BC_VERSION = 1.06.95
BC_SOURCE = bc-$(BC_VERSION).tar.bz2
BC_SITE = http://alpha.gnu.org/gnu/bc
BC_DEPENDENCIES = host-flex
BC_LICENSE = GPL-2.0+, LGPL-2.1+
BC_LICENSE_FILES = COPYING COPYING.LIB

$(eval $(autotools-package))
