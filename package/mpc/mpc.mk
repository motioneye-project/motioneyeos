#############################################################
#
# mpc
#
#############################################################

MPC_VERSION = 0.9
MPC_SITE = http://www.multiprecision.org/mpc/download
MPC_INSTALL_STAGING = YES
MPC_DEPENDENCIES = gmp mpfr
MPC_AUTORECONF = YES
HOST_MPC_AUTORECONF = YES

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))
