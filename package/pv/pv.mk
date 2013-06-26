################################################################################
#
# pv
#
################################################################################

PV_VERSION = 1.4.6
PV_SOURCE = pv-$(PV_VERSION).tar.bz2
PV_SITE = http://www.ivarch.com/programs/sources
PV_MAKE_OPT = LD=$(TARGET_LD) # otherwise 'ld' is used

$(eval $(autotools-package))
