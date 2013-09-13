################################################################################
#
# erlang
#
################################################################################

ERLANG_VERSION = R16B01
ERLANG_SITE = http://www.erlang.org/download
ERLANG_SOURCE = otp_src_$(ERLANG_VERSION).tar.gz
ERLANG_DEPENDENCIES = host-erlang
HOST_ERLANG_DEPENDENCIES =

ERLANG_LICENSE = EPL
ERLANG_LICENSE_FILES = EPLICENCE
ERLANG_INSTALL_STAGING = YES

# The configure checks for these functions fail incorrectly
ERLANG_CONF_ENV = ac_cv_func_isnan=yes ac_cv_func_isinf=yes

# Set erl_xcomp variables. See xcomp/erl-xcomp.conf.template
# for documentation.
ERLANG_CONF_ENV += erl_xcomp_sysroot=$(STAGING_DIR)

ERLANG_CONF_OPT = --without-javac
HOST_ERLANG_CONF_OPT = --without-javac

ifeq ($(BR2_PACKAGE_NCURSES),y)
ERLANG_CONF_OPT += --with-termcap
ERLANG_DEPENDENCIES += ncurses
else
ERLANG_CONF_OPT += --without-termcap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ERLANG_CONF_OPT += --with-ssl
ERLANG_DEPENDENCIES += openssl
else
ERLANG_CONF_OPT += --without-ssl
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ERLANG_CONF_OPT += --enable-shared-zlib
ERLANG_DEPENDENCIES += zlib
endif

# Remove source, example, gs and wx files from the target
ERLANG_REMOVE_PACKAGES = gs wx

ifneq ($(BR2_PACKAGE_ERLANG_MEGACO),y)
ERLANG_REMOVE_PACKAGES += megaco
endif

define ERLANG_REMOVE_UNUSED
	find $(TARGET_DIR)/usr/lib/erlang -type d -name src -prune -exec rm -rf {} \;
	find $(TARGET_DIR)/usr/lib/erlang -type d -name examples -prune -exec rm -rf {} \;
	for package in $(ERLANG_REMOVE_PACKAGES); do \
		rm -rf $(TARGET_DIR)/usr/lib/erlang/lib/$${package}-*; \
	done
endef

ERLANG_POST_INSTALL_TARGET_HOOKS += ERLANG_REMOVE_UNUSED

$(eval $(autotools-package))
$(eval $(host-autotools-package))
