#############################################################
#
# mpc
#
#############################################################

MPC_VERSION = 0.8.2
MPC_SITE = http://www.multiprecision.org/mpc/download
MPC_INSTALL_STAGING = YES
MPC_DEPENDENCIES = gmp mpfr
HOST_MPC_DEPENDENCIES = host-gmp host-mpfr

$(eval $(call AUTOTARGETS,package,mpc))
$(eval $(call AUTOTARGETS,package,mpc,host))
