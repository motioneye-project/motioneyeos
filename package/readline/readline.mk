################################################################################
#
# readline
#
################################################################################

READLINE_VERSION = 7.0
READLINE_SITE = $(BR2_GNU_MIRROR)/readline
READLINE_INSTALL_STAGING = YES
READLINE_DEPENDENCIES = ncurses host-autoconf
HOST_READLINE_DEPENDENCIES = host-ncurses host-autoconf
READLINE_CONF_ENV = bash_cv_func_sigsetjmp=yes \
	bash_cv_wcwidth_broken=no
READLINE_LICENSE = GPL-3.0+
READLINE_LICENSE_FILES = COPYING

# readline only uses autoconf, not automake, and therefore the regular
# AUTORECONF = YES doesn't work.
define READLINE_AUTOCONF
	cd $(@D); $(HOST_DIR)/bin/autoconf
endef
READLINE_PRE_CONFIGURE_HOOKS += READLINE_AUTOCONF
HOST_READLINE_PRE_CONFIGURE_HOOKS += READLINE_AUTOCONF

define READLINE_PURGE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/share/readline
endef
READLINE_POST_INSTALL_TARGET_HOOKS += READLINE_PURGE_EXAMPLES

define READLINE_INSTALL_PC_FILE
	$(INSTALL) -D -m 644 $(@D)/readline.pc $(STAGING_DIR)/usr/lib/pkgconfig/readline.pc
endef
READLINE_POST_INSTALL_STAGING_HOOKS += READLINE_INSTALL_PC_FILE

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
