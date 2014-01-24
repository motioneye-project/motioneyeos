###############################################################################
#
# tmux
#
###############################################################################

TMUX_VERSION = 1.8
TMUX_SITE = http://downloads.sourceforge.net/tmux
TMUX_LICENSE = ISC
TMUX_LICENSE_FILES = README
TMUX_DEPENDENCIES = libevent ncurses host-pkgconf

$(eval $(autotools-package))
