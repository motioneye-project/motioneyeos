################################################################################
#
# erlang
#
################################################################################

# See note below when updating Erlang
ERLANG_VERSION = 20.0
ERLANG_SITE = http://www.erlang.org/download
ERLANG_SOURCE = otp_src_$(ERLANG_VERSION).tar.gz
ERLANG_DEPENDENCIES = host-erlang

ERLANG_LICENSE = Apache-2.0
ERLANG_LICENSE_FILES = LICENSE.txt
ERLANG_INSTALL_STAGING = YES

# Patched erts/aclocal.m4
ERLANG_AUTORECONF = YES

# Whenever updating Erlang, this value should be updated as well, to the
# value of EI_VSN in the file lib/erl_interface/vsn.mk
ERLANG_EI_VSN = 3.10

# The configure checks for these functions fail incorrectly
ERLANG_CONF_ENV = ac_cv_func_isnan=yes ac_cv_func_isinf=yes

# Set erl_xcomp variables. See xcomp/erl-xcomp.conf.template
# for documentation.
ERLANG_CONF_ENV += erl_xcomp_sysroot=$(STAGING_DIR)

ERLANG_CONF_OPTS = --without-javac

# Force ERL_TOP to the downloaded source directory. This prevents
# Erlang's configure script from inadvertantly using files from
# a version of Erlang installed on the host.
ERLANG_CONF_ENV += ERL_TOP=$(@D)
HOST_ERLANG_CONF_ENV += ERL_TOP=$(@D)

# erlang uses openssl for all things crypto. Since the host tools (such as
# rebar) uses crypto, we need to build host-erlang with support for openssl.
HOST_ERLANG_DEPENDENCIES = host-openssl
HOST_ERLANG_CONF_OPTS = --without-javac --with-ssl=$(HOST_DIR)

HOST_ERLANG_CONF_OPTS += --without-termcap

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
ERLANG_CONF_OPTS += --disable-threads
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
ERLANG_CONF_OPTS += --with-termcap
ERLANG_DEPENDENCIES += ncurses
else
ERLANG_CONF_OPTS += --without-termcap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ERLANG_CONF_OPTS += --with-ssl
ERLANG_DEPENDENCIES += openssl
else
ERLANG_CONF_OPTS += --without-ssl
endif

# ODBC support in erlang requires threads
ifeq ($(BR2_PACKAGE_UNIXODBC)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
ERLANG_DEPENDENCIES += unixodbc
ERLANG_CONF_OPTS += --with-odbc
else
ERLANG_CONF_OPTS += --without-odbc
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ERLANG_CONF_OPTS += --enable-shared-zlib
ERLANG_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_ERLANG_SMP),)
ERLANG_CONF_OPTS += --disable-smp-support
endif

# Remove source, example, gs and wx files from staging and target.
ERLANG_REMOVE_PACKAGES = gs wx

ifneq ($(BR2_PACKAGE_ERLANG_MEGACO),y)
ERLANG_REMOVE_PACKAGES += megaco
endif

define ERLANG_REMOVE_STAGING_UNUSED
	for package in $(ERLANG_REMOVE_PACKAGES); do \
		rm -rf $(STAGING_DIR)/usr/lib/erlang/lib/$${package}-*; \
	done
endef

define ERLANG_REMOVE_TARGET_UNUSED
	find $(TARGET_DIR)/usr/lib/erlang -type d -name src -prune -exec rm -rf {} \;
	find $(TARGET_DIR)/usr/lib/erlang -type d -name examples -prune -exec rm -rf {} \;
	for package in $(ERLANG_REMOVE_PACKAGES); do \
		rm -rf $(TARGET_DIR)/usr/lib/erlang/lib/$${package}-*; \
	done
endef

ERLANG_POST_INSTALL_STAGING_HOOKS += ERLANG_REMOVE_STAGING_UNUSED
ERLANG_POST_INSTALL_TARGET_HOOKS += ERLANG_REMOVE_TARGET_UNUSED

$(eval $(autotools-package))
$(eval $(host-autotools-package))
