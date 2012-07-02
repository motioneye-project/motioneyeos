#############################################################
#
# mpc
#
#############################################################

MPC_VERSION = 0.9
MPC_SITE = http://www.multiprecision.org/mpc/download
MPC_LICENSE = LGPLv2.1+
MPC_LICENSE_FILES = COPYING.LIB
MPC_INSTALL_STAGING = YES
MPC_DEPENDENCIES = gmp mpfr
MPC_AUTORECONF = YES
HOST_MPC_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
