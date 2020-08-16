################################################################################
#
# bash-completion
#
################################################################################

BASH_COMPLETION_VERSION = 2.10
BASH_COMPLETION_SITE = https://github.com/scop/bash-completion/releases/download/$(BASH_COMPLETION_VERSION)
BASH_COMPLETION_SOURCE = bash-completion-$(BASH_COMPLETION_VERSION).tar.xz
BASH_COMPLETION_LICENSE = GPL-2.0
BASH_COMPLETION_LICENSE_FILES = COPYING

# Install bash-completion.pc file
BASH_COMPLETION_INSTALL_STAGING = YES

$(eval $(autotools-package))
