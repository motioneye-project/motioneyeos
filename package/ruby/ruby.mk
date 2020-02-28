################################################################################
#
# ruby
#
################################################################################

RUBY_VERSION_MAJOR = 2.4
RUBY_VERSION = $(RUBY_VERSION_MAJOR).9
RUBY_VERSION_EXT = 2.4.0
RUBY_SITE = http://cache.ruby-lang.org/pub/ruby/$(RUBY_VERSION_MAJOR)
RUBY_SOURCE = ruby-$(RUBY_VERSION).tar.xz
RUBY_DEPENDENCIES = host-pkgconf host-ruby
HOST_RUBY_DEPENDENCIES = host-pkgconf host-openssl
RUBY_MAKE_ENV = $(TARGET_MAKE_ENV)
RUBY_CONF_OPTS = --disable-install-doc --disable-rpath --disable-rubygems
HOST_RUBY_CONF_OPTS = \
	--disable-install-doc \
	--with-out-ext=curses,readline \
	--without-gmp
RUBY_LICENSE = Ruby or BSD-2-Clause, BSD-3-Clause, others
RUBY_LICENSE_FILES = LEGAL COPYING BSDL

RUBY_CFLAGS = $(TARGET_CFLAGS)
# With some SuperH toolchains (like Sourcery CodeBench 2012.09), ruby fails to
# build with 'pcrel too far'. This seems to be caused by the -Os option we pass
# by default. To fix the problem, use standard -O2 optimization instead.
ifeq ($(BR2_sh),y)
RUBY_CFLAGS += -O2
endif
RUBY_CONF_ENV = CFLAGS="$(RUBY_CFLAGS)"

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# On uClibc, finite, isinf and isnan are not directly implemented as
# functions.  Instead math.h #define's these to __finite, __isinf and
# __isnan, confusing the Ruby configure script. Tell it that they
# really are available.
RUBY_CONF_ENV += \
	ac_cv_func_finite=yes \
	ac_cv_func_isinf=yes \
	ac_cv_func_isnan=yes
endif

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),)
RUBY_CONF_ENV += stack_protector=no
endif

# Force optionals to build before we do
ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
RUBY_DEPENDENCIES += berkeleydb
endif
ifeq ($(BR2_PACKAGE_LIBFFI),y)
RUBY_DEPENDENCIES += libffi
else
# Disable fiddle to avoid a build failure with bundled-libffi on MIPS
RUBY_CONF_OPTS += --with-out-ext=fiddle
endif
ifeq ($(BR2_PACKAGE_GDBM),y)
RUBY_DEPENDENCIES += gdbm
endif
ifeq ($(BR2_PACKAGE_LIBYAML),y)
RUBY_DEPENDENCIES += libyaml
endif
ifeq ($(BR2_PACKAGE_NCURSES),y)
RUBY_DEPENDENCIES += ncurses
endif
ifeq ($(BR2_PACKAGE_OPENSSL),y)
RUBY_DEPENDENCIES += openssl
endif
ifeq ($(BR2_PACKAGE_READLINE),y)
RUBY_DEPENDENCIES += readline
endif
ifeq ($(BR2_PACKAGE_ZLIB),y)
RUBY_DEPENDENCIES += zlib
endif
ifeq ($(BR2_PACKAGE_GMP),y)
RUBY_DEPENDENCIES += gmp
RUBY_CONF_OPTS += --with-gmp
else
RUBY_CONF_OPTS += --without-gmp
endif

# workaround for amazing build failure, see
# http://lists.busybox.net/pipermail/buildroot/2014-December/114273.html
define RUBY_REMOVE_VERCONF_H
	rm -f $(@D)/verconf.h
endef
RUBY_POST_CONFIGURE_HOOKS += RUBY_REMOVE_VERCONF_H

# Remove rubygems and friends, as they need extensions that aren't
# built and a target compiler.
RUBY_EXTENSIONS_REMOVE = rake* rdoc* rubygems*
define RUBY_REMOVE_RUBYGEMS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, gem rdoc ri rake)
	rm -rf $(TARGET_DIR)/usr/lib/ruby/gems
	rm -rf $(addprefix $(TARGET_DIR)/usr/lib/ruby/$(RUBY_VERSION_EXT)/, \
		$(RUBY_EXTENSIONS_REMOVE))
endef
RUBY_POST_INSTALL_TARGET_HOOKS += RUBY_REMOVE_RUBYGEMS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
