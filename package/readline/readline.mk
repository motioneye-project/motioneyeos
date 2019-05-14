################################################################################
#
# readline
#
################################################################################

READLINE_VERSION = 8.0
READLINE_SITE = $(BR2_GNU_MIRROR)/readline
READLINE_INSTALL_STAGING = YES
READLINE_DEPENDENCIES = ncurses host-autoconf
HOST_READLINE_DEPENDENCIES = host-ncurses host-autoconf
READLINE_CONF_ENV = bash_cv_func_sigsetjmp=yes \
	bash_cv_wcwidth_broken=no
READLINE_CONF_OPTS = --disable-install-examples
READLINE_LICENSE = GPL-3.0+
READLINE_LICENSE_FILES = COPYING

define READLINE_INSTALL_INPUTRC
	$(INSTALL) -D -m 644 package/readline/inputrc $(TARGET_DIR)/etc/inputrc
endef
READLINE_POST_INSTALL_TARGET_HOOKS += READLINE_INSTALL_INPUTRC

$(eval $(autotools-package))
$(eval $(host-autotools-package))
