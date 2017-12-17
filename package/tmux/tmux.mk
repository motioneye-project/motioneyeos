################################################################################
#
# tmux
#
################################################################################

TMUX_VERSION = 2.6
TMUX_SITE = https://github.com/tmux/tmux/releases/download/$(TMUX_VERSION)
TMUX_LICENSE = ISC
TMUX_LICENSE_FILES = README
TMUX_DEPENDENCIES = libevent ncurses host-pkgconf

$(eval $(autotools-package))
