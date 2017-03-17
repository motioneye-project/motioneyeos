################################################################################
#
# readline
#
################################################################################

READLINE_VERSION = 7.0
READLINE_SITE = $(BR2_GNU_MIRROR)/readline
READLINE_INSTALL_STAGING = YES
READLINE_DEPENDENCIES = ncurses
HOST_READLINE_DEPENDENCIES = host-ncurses
READLINE_CONF_ENV = bash_cv_func_sigsetjmp=yes \
	bash_cv_wcwidth_broken=no
READLINE_LICENSE = GPLv3+
READLINE_LICENSE_FILES = COPYING

define READLINE_PURGE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/readline
endef
READLINE_POST_INSTALL_TARGET_HOOKS += READLINE_PURGE_EXAMPLES

define READLINE_INSTALL_INPUTRC
	$(INSTALL) -D -m 644 package/readline/inputrc $(TARGET_DIR)/etc/inputrc
endef
READLINE_POST_INSTALL_TARGET_HOOKS += READLINE_INSTALL_INPUTRC

ifneq ($(BR2_STATIC_LIBS),y)
# libraries get installed read only, so strip fails
define READLINE_INSTALL_FIXUPS_SHARED
	chmod +w $(addprefix $(TARGET_DIR)/usr/lib/,libhistory.so.* libreadline.so.*)
endef
READLINE_POST_INSTALL_TARGET_HOOKS += READLINE_INSTALL_FIXUPS_SHARED
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
