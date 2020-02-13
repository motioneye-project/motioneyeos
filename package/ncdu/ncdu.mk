################################################################################
#
# ncdu
#
################################################################################

NCDU_VERSION = 1.14.2
NCDU_SITE = http://dev.yorhel.nl/download

NCDU_DEPENDENCIES = ncurses

NCDU_LICENSE = MIT
NCDU_LICENSE_FILES = COPYING

$(eval $(autotools-package))
