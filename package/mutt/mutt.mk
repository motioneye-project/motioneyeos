#############################################################
#
# mutt
#
#############################################################

MUTT_VERSION = 1.5.21
MUTT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mutt
MUTT_DEPENDENCIES = ncurses
MUTT_CONF_OPT = --disable-iconv --disable-smtp
MUTT_AUTORECONF = YES

$(eval $(autotools-package))
