################################################################################
#
# rtptools
#
################################################################################

RTPTOOLS_VERSION = 1.22
RTPTOOLS_SITE = http://www.cs.columbia.edu/irt/software/rtptools/download
RTPTOOLS_LICENSE = BSD-3-Clause
RTPTOOLS_LICENSE_FILES = LICENSE
RTPTOOLS_CONF_ENV = ac_cv_prog_FOUND_CLANG=no

$(eval $(autotools-package))
