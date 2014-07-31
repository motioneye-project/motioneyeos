################################################################################
#
# iftop
#
################################################################################

IFTOP_VERSION = 1.0pre4
IFTOP_SITE = http://www.ex-parrot.com/pdw/iftop/download
IFTOP_DEPENDENCIES = ncurses libpcap
IFTOP_LICENSE = GPLv2+
IFTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
