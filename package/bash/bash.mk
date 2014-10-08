################################################################################
#
# bash
#
################################################################################

BASH_VERSION = 4.3
BASH_SITE = $(BR2_GNU_MIRROR)/bash
# Build after since bash is better than busybox shells
BASH_DEPENDENCIES = ncurses readline host-bison \
	$(if $(BR2_PACKAGE_BUSYBOX),busybox)
BASH_CONF_OPTS = --with-installed-readline
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
BASH_CONF_OPTS += --enable-static-link --without-bash-malloc
endif

# Make /bin/sh -> bash (no other shell, better than busybox shells)
define BASH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) exec_prefix=/ install
	rm -f $(TARGET_DIR)/bin/bashbug
	ln -sf bash $(TARGET_DIR)/bin/sh
endef

$(eval $(autotools-package))
