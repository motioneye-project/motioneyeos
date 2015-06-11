################################################################################
#
# kyua
#
################################################################################

KYUA_VERSION = 0.11
KYUA_SITE = https://github.com/jmmv/kyua/releases/download/kyua-$(KYUA_VERSION)
KYUA_DEPENDENCIES = host-pkgconf atf lutok sqlite
KYUA_CONF_OPTS = --without-doxygen --without-atf
KYUA_LICENSE = BSD-3c
KYUA_LICENSE_FILES = COPYING
KYUA_CONF_ENV = \
	kyua_cv_attribute_noreturn=yes \
	kyua_cv_getcwd_dyn=yes \
	kyua_cv_lchmod_works=no \
	kyua_cv_getopt_gnu=yes \
	kyua_cv_getopt_optind_reset_value=0 \
	kyua_cv_signals_lastno=15

define KYUA_INSTALL_CONFIG
	$(INSTALL) -D -m 644 $(@D)/examples/kyua.conf $(TARGET_DIR)/etc/kyua/kyua.conf
endef

KYUA_POST_INSTALL_HOOKS += KYUA_INSTALL_CONFIG

$(eval $(autotools-package))
