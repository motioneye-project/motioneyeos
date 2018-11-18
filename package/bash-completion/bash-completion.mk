################################################################################
#
# bash-completion
#
################################################################################

BASH_COMPLETION_VERSION = 2.8
BASH_COMPLETION_SITE = https://github.com/scop/bash-completion/releases/download/$(BASH_COMPLETION_VERSION)
BASH_COMPLETION_SOURCE = bash-completion-$(BASH_COMPLETION_VERSION).tar.xz
BASH_COMPLETION_LICENSE = GPL-2.0
BASH_COMPLETION_LICENSE_FILES = COPYING

# 0001-completions-Makefile.am-Use-install-data-hook-not-in.patch
BASH_COMPLETION_AUTORECONF = YES

# Install bash-completion.pc file
BASH_COMPLETION_INSTALL_STAGING = YES

$(eval $(autotools-package))
