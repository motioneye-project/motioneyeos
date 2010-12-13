#############################################################
#
# ltp-testsuite
#
#############################################################
LTP_TESTSUITE_VERSION = 20101031
LTP_TESTSUITE_SOURCE  = ltp-full-$(LTP_TESTSUITE_VERSION).bz2
LTP_TESTSUITE_SITE    = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ltp

$(eval $(call AUTOTARGETS,package,ltp-testsuite))
