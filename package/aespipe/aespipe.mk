################################################################################
#
# aespipe
#
################################################################################

AESPIPE_VERSION = 2.4d
AESPIPE_SOURCE = aespipe-v$(AESPIPE_VERSION).tar.bz2
AESPIPE_SITE = http://loop-aes.sourceforge.net/aespipe
AESPIPE_LICENSE = GPL

$(eval $(autotools-package))
$(eval $(host-autotools-package))
