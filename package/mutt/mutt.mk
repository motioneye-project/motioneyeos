################################################################################
#
# mutt
#
################################################################################

MUTT_VERSION = 1.5.21
MUTT_SITE = http://downloads.sourceforge.net/project/mutt/mutt-dev
MUTT_LICENSE = GPLv2+
MUTT_LICENSE_FILES = GPL
MUTT_DEPENDENCIES = ncurses
MUTT_CONF_OPT = --disable-iconv --disable-smtp
MUTT_AUTORECONF = YES

$(eval $(autotools-package))
