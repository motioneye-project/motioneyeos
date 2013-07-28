################################################################################
#
# ser2net
#
################################################################################

SER2NET_VERSION = 2.9
SER2NET_SITE = http://downloads.sourceforge.net/project/ser2net/ser2net
# shipped configure script is broken (libtool version error)
SER2NET_AUTORECONF = YES
SER2NET_LICENSE = GPLv2+
SER2NET_LICENSE_FILES = COPYING

$(eval $(autotools-package))
