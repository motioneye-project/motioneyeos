################################################################################
#
# rtptools
#
################################################################################

RTPTOOLS_VERSION = 1.20
RTPTOOLS_SITE = http://www.cs.columbia.edu/irt/software/rtptools/download
RTPTOOLS_LICENSE = MIT-like (research and education only)
RTPTOOLS_LICENSE_FILES = COPYRIGHT
RTPTOOLS_AUTORECONF = YES

$(eval $(autotools-package))
