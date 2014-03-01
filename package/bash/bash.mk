################################################################################
#
# bash
#
################################################################################

BASH_VERSION = 4.3
BASH_SITE = $(BR2_GNU_MIRROR)/bash
BASH_DEPENDENCIES = ncurses readline host-bison
BASH_CONF_OPT = --with-installed-readline
BASH_LICENSE = GPLv3+
BASH_LICENSE_FILES = COPYING

BASH_CONF_ENV += \
	ac_cv_rl_prefix="$(STAGING_DIR)" \
	ac_cv_rl_version="$(READLINE_VERSION)" \
	bash_cv_job_control_missing=present \
	bash_cv_sys_named_pipes=present \
	bash_cv_func_sigsetjmp=present \
	bash_cv_printf_a_format=yes

# Parallel build sometimes fails because some of the generator tools
# are built twice (i.e. while executing).
BASH_MAKE = $(MAKE1)

# The static build needs some trickery
ifeq ($(BR2_PREFER_STATIC_LIB),y)
BASH_CONF_OPT += --enable-static-link --without-bash-malloc
endif

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

$(eval $(autotools-package))
