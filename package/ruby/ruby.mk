#############################################################
#
# ruby
#
#############################################################
RUBY_VERSION:=1.9.1-p129
RUBY_SOURCE:=ruby-$(RUBY_VERSION).tar.gz
RUBY_SITE:=ftp://ftp.ruby-lang.org/pub/ruby/1.9
RUBY_AUTORECONF=YES
RUBY_DEPENDENCIES=host-ruby
RUBY_INSTALL_TARGET_OPT=DESTDIR=$(TARGET_DIR) install
RUBY_MAKE_ENV=$(TARGET_MAKE_ENV)

RUBY_CONF_OPT = --disable-install-doc

$(eval $(call AUTOTARGETS,package,ruby))
$(eval $(call AUTOTARGETS,package,ruby,host))
