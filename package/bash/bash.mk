#############################################################
#
# bash
#
#############################################################

BASH_VERSION = 4.2
BASH_SITE = $(BR2_GNU_MIRROR)/bash
BASH_DEPENDENCIES = ncurses
BASH_CONF_ENV +=                       \
   bash_cv_job_control_missing=present \
   bash_cv_sys_named_pipes=present     \
   bash_cv_func_sigsetjmp=present      \
   bash_cv_printf_a_format=yes

# Make sure we build after busybox so that /bin/sh links to bash
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
BASH_DEPENDENCIES += busybox
endif

# Save the old sh file/link if there is one and symlink bash->sh
define BASH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) exec_prefix=/ install
	rm -f $(TARGET_DIR)/bin/bashbug
	if [ -e $(TARGET_DIR)/bin/sh ]; then \
		mv -f $(TARGET_DIR)/bin/sh $(TARGET_DIR)/bin/sh.prebash; \
	fi
	ln -sf bash $(TARGET_DIR)/bin/sh
endef

# Restore the old shell file/link if there was one
define BASH_UNINSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) \
		-C $(BASH_DIR) exec_prefix=/ uninstall
	rm -f $(TARGET_DIR)/bin/sh
	if [ -e $(TARGET_DIR)/bin/sh.prebash ]; then \
		mv -f $(TARGET_DIR)/bin/sh.prebash $(TARGET_DIR)/bin/sh; \
	fi
endef

$(eval $(autotools-package))
