################################################################################
#
# genpart
#
################################################################################

GENPART_VERSION = 1.0.2
GENPART_SOURCE = genpart-$(GENPART_VERSION).tar.bz2
GENPART_SITE = http://www.pengutronix.de/software/genpart/download
# genpart has no license embedded in its source release.
# However, their project page mentions:
#   > This community portal offers an overview about our own OSS
#   > projects and projects Pengutronix is or was involved with.
# We can thus assume genpart is under a FLOSS license.
# So, until the authors have clarified the licensing terms:
GENPART_LICENSE = Unknown (clarification has been asked to the authors)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
