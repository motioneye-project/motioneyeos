################################################################################
#
# ejabberd
#
################################################################################

EJABBERD_VERSION = 17.11
EJABBERD_SOURCE = ejabberd-$(EJABBERD_VERSION).tgz
EJABBERD_SITE = https://www.process-one.net/downloads/ejabberd/$(EJABBERD_VERSION)
EJABBERD_LICENSE = GPL-2.0+ with OpenSSL exception
EJABBERD_LICENSE_FILES = COPYING
EJABBERD_DEPENDENCIES = getent openssl host-erlang-lager erlang-lager \
	erlang-p1-cache-tab erlang-p1-iconv erlang-p1-sip \
	erlang-p1-stringprep erlang-p1-stun erlang-p1-tls \
	erlang-p1-utils erlang-p1-xml erlang-p1-xmpp erlang-p1-yaml \
	erlang-p1-zlib host-erlang-p1-utils host-erlang-p1-xmpp

# 0001-remove-make-targets-for-deps.patch updates Makefile.in
EJABBERD_USE_AUTOCONF = YES
EJABBERD_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
EJABBERD_DEPENDENCIES += linux-pam
endif

EJABBERD_ERLANG_LIBS = sasl public_key mnesia inets compiler

# Guess answers for these tests, configure will bail out otherwise
# saying error: cannot run test program while cross compiling.
EJABBERD_CHECK_LIB = $(TOPDIR)/$(EJABBERD_PKGDIR)/check-erlang-lib
EJABBERD_CONF_ENV = \
	ac_cv_erlang_root_dir="$(HOST_DIR)/lib/erlang" \
	$(foreach lib,$(EJABBERD_ERLANG_LIBS), \
		ac_cv_erlang_lib_dir_$(lib)="`$(EJABBERD_CHECK_LIB) $(lib)`")

EJABBERD_CONF_OPTS = \
	--enable-system-deps \
	--disable-erlang-version-check \
	--disable-graphics

define EJABBERD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) install -C $(@D)
endef

# Replace HOST_DIR prefix to /usr in environment variables of
# ejabberctl script.
define EJABBERD_FIX_EJABBERDCTL
	$(SED) 's,="$(HOST_DIR),="/usr,' '$(TARGET_DIR)/usr/sbin/ejabberdctl'
endef

EJABBERD_POST_INSTALL_TARGET_HOOKS += EJABBERD_FIX_EJABBERDCTL

define EJABBERD_USERS
	ejabberd -1 ejabberd -1 * /var/lib/ejabberd /bin/sh - ejabberd daemon
endef

define EJABBERD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/ejabberd/S50ejabberd \
		$(TARGET_DIR)/etc/init.d/S50ejabberd
endef

$(eval $(rebar-package))
