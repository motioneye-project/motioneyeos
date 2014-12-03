################################################################################
#
# bash
#
################################################################################

BASH_VERSION = 4.3.30
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
ifeq ($(BR2_STATIC_LIBS),y)
BASH_CONF_OPTS += --enable-static-link --without-bash-malloc
# bash wants to redefine the getenv() function. To check whether this is
# possible, AC_TRY_RUN is used which is not possible in
# cross-compilation.
# On uClibc, redefining getenv is not possible; on glibc and musl it is.
# Related:
# http://lists.gnu.org/archive/html/bug-bash/2012-03/msg00052.html
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
BASH_CONF_ENV += bash_cv_getenv_redef=no
else
BASH_CONF_ENV += bash_cv_getenv_redef=yes
endif
endif

# Make /bin/sh -> bash (no other shell, better than busybox shells)
define BASH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR) exec_prefix=/ install
	rm -f $(TARGET_DIR)/bin/bashbug
endef

$(eval $(autotools-package))
