#############################################################
#
# ltp-testsuite
#
#############################################################
LTP_TESTSUITE_VERSION = 20101031
LTP_TESTSUITE_SOURCE  = ltp-full-$(LTP_TESTSUITE_VERSION).bz2
LTP_TESTSUITE_SITE    = http://downloads.sourceforge.net/project/ltp/LTP%20Source/ltp-$(LTP_TESTSUITE_VERSION)

$(eval $(autotools-package))
