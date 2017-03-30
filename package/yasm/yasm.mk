################################################################################
#
# yasm
#
################################################################################

YASM_VERSION = 1.3.0
YASM_SITE = http://www.tortall.net/projects/yasm/releases
YASM_LICENSE = BSD-2-Clause, BSD-3-Clause, Artistic, GPL-2.0, LGPL-2.0
YASM_LICENSE_FILES = COPYING BSD.txt Artistic.txt GNU_GPL-2.0 GNU_LGPL-2.0

# This sed prevents it compiling 2 programs (vsyasm and ytasm)
# that are only of use on Microsoft Windows.
define YASM_PRE_CONFIGURE_FIXUP
	$(SED) 's#) ytasm.*#)#' $(@D)/Makefile.in
endef

YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP
HOST_YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
