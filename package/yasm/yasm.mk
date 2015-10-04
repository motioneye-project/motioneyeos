################################################################################
#
# yasm
#
################################################################################

YASM_VERSION = 1.2.0
YASM_SITE = http://www.tortall.net/projects/yasm/releases

define YASM_PRE_CONFIGURE_FIXUP
# This sed prevents it compiling 2 programs (vsyasm and ytasm) 
# that are only of use on Microsoft Windows. 
	sed -i 's#) ytasm.*#)#' $(@D)/Makefile.in
endef

YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP
HOST_YASM_PRE_CONFIGURE_HOOKS += YASM_PRE_CONFIGURE_FIXUP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
