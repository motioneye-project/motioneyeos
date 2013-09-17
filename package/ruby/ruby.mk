################################################################################
#
# ruby
#
################################################################################

RUBY_VERSION = 1.9.3-p448
RUBY_SITE = ftp://ftp.ruby-lang.org/pub/ruby/1.9
RUBY_DEPENDENCIES = host-pkgconf host-ruby
HOST_RUBY_DEPENDENCIES = host-pkgconf
RUBY_MAKE_ENV = $(TARGET_MAKE_ENV)
RUBY_MAKE = $(MAKE1)
RUBY_CONF_OPT = --disable-install-doc --disable-rpath
HOST_RUBY_CONF_OPT = --disable-install-doc --with-out-ext=curses,readline
RUBY_LICENSE = Ruby
RUBY_LICENSE_FILES = LEGAL

# Force optionals to build before we do
ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
	RUBY_DEPENDENCIES += berkeleydb
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

$(eval $(autotools-package))
$(eval $(host-autotools-package))
