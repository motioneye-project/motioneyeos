################################################################################
#
# zsh
#
################################################################################

ZSH_VERSION=5.0.2
ZSH_SITE=http://downloads.sourceforge.net/project/zsh/zsh/$(ZSH_VERSION)
ZSH_LICENSE = MIT-like
ZSH_LICENSE_FILES = LICENCE

ZSH_DEPENDENCIES = ncurses

$(eval $(autotools-package))
