################################################################################
#
# yasm
#
################################################################################

YASM_VERSION = 1.3.0
YASM_SITE = http://www.tortall.net/projects/yasm/releases

# This sed prevents it compiling 2 programs (vsyasm and ytasm)
# that are only of use on Microsoft Windows.
define YASM_PRE_CONFIGURE_FIXUP
	$(SED) 's#) ytasm.*#)#' $(@D)/Makefile.in
endef

YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP
HOST_YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
