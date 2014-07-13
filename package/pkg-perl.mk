################################################################################
# Perl package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for Perl packages.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this perl infrastructure requires
# the .mk file to only specify metadata information about the
# package: name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default perl behaviour. The
# package can also define some post operation hooks.
#
################################################################################

PERL_ARCHNAME	= $(ARCH)-linux

################################################################################
# inner-perl-package -- defines how the configuration, compilation and
# installation of a perl package should be done, implements a
# few hooks to tune the build process for perl specifities and
# calls the generic package infrastructure to generate the necessary
# make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including an HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-perl-package

#
# Configure step. Only define it if not already defined by the package
# .mk file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_CONFIGURE_CMDS
ifeq ($(4),target)

# Configure package for target
define $(2)_CONFIGURE_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		$$($(2)_CONF_ENV) \
		PERL_MM_USE_DEFAULT=1 \
		perl Build.PL \
			--config ar="$$(TARGET_AR)" \
			--config full_ar="$$(TARGET_AR)" \
			--config cc="$$(TARGET_CC)" \
			--config ccflags="$$(TARGET_CFLAGS)" \
			--config ld="$$(TARGET_CC)" \
			--config lddlflags="-shared $$(TARGET_LDFLAGS)" \
			--config ldflags="$$(TARGET_LDFLAGS)" \
			--include_dirs $$(STAGING_DIR)/usr/lib/perl5/$$(PERL_VERSION)/$$(PERL_ARCHNAME)/CORE \
			--destdir $$(TARGET_DIR) \
			--installdirs vendor \
			--install_path lib=/usr/lib/perl5/site_perl/$$(PERL_VERSION) \
			--install_path arch=/usr/lib/perl5/site_perl/$$(PERL_VERSION)/$$(PERL_ARCHNAME) \
			--install_path bin=/usr/bin \
			--install_path script=/usr/bin \
			--install_path bindoc=/usr/share/man/man1 \
			--install_path libdoc=/usr/share/man/man3 \
			$$($(2)_CONF_OPT); \
	else \
		$$($(2)_CONF_ENV) \
		PERL_MM_USE_DEFAULT=1 \
		PERL_AUTOINSTALL=--skipdeps \
		perl Makefile.PL \
			AR="$$(TARGET_AR)" \
			FULL_AR="$$(TARGET_AR)" \
			CC="$$(TARGET_CC)" \
			CCFLAGS="$$(TARGET_CFLAGS)" \
			LD="$$(TARGET_CC)" \
			LDDLFLAGS="-shared $$(TARGET_LDFLAGS)" \
			LDFLAGS="$$(TARGET_LDFLAGS)" \
			DESTDIR=$$(TARGET_DIR) \
			INSTALLDIRS=vendor \
			INSTALLVENDORLIB=/usr/lib/perl5/site_perl/$$(PERL_VERSION) \
			INSTALLVENDORARCH=/usr/lib/perl5/site_perl/$$(PERL_VERSION)/$$(PERL_ARCHNAME) \
			INSTALLVENDORBIN=/usr/bin \
			INSTALLVENDORSCRIPT=/usr/bin \
			INSTALLVENDORMAN1DIR=/usr/share/man/man1 \
			INSTALLVENDORMAN3DIR=/usr/share/man/man3 \
			$$($(2)_CONF_OPT); \
	fi
endef
else

# Configure package for host
define $(2)_CONFIGURE_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		$$($(2)_CONF_ENV) \
		PERL_MM_USE_DEFAULT=1 \
		perl Build.PL \
			--install_base $$(HOST_DIR)/usr \
			--installdirs vendor \
			$$($(2)_CONF_OPT); \
	else \
		$$($(2)_CONF_ENV) \
		PERL_MM_USE_DEFAULT=1 \
		PERL_AUTOINSTALL=--skipdeps \
		perl Makefile.PL \
			INSTALL_BASE=$$(HOST_DIR)/usr \
			INSTALLDIRS=vendor \
			$$($(2)_CONF_OPT); \
	fi
endef
endif
endif

#
# Build step. Only define it if not already defined by the package .mk
# file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_BUILD_CMDS
ifeq ($(4),target)

# Build package for target
define $(2)_BUILD_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		perl Build $$($(2)_BUILD_OPT) build; \
	else \
		$$(MAKE1) \
			PERL_INC=$$(STAGING_DIR)/usr/lib/perl5/$$(PERL_VERSION)/$$(PERL_ARCHNAME)/CORE \
			$$($(2)_BUILD_OPT) pure_all; \
	fi
endef
else

# Build package for host
define $(2)_BUILD_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		perl Build $$($(2)_BUILD_OPT) build; \
	else \
		$$(MAKE1) $$($(2)_BUILD_OPT) pure_all; \
	fi
endef
endif
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		perl Build $$($(2)_INSTALL_TARGET_OPT) install; \
	else \
		$$(MAKE1) $$($(2)_INSTALL_TARGET_OPT) pure_install; \
	fi
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	cd $$($$(PKG)_SRCDIR) && if [ -f Build.PL ] ; then \
		perl Build $$($(2)_INSTALL_TARGET_OPT) install; \
	else \
		$$(MAKE1) $$($(2)_INSTALL_TARGET_OPT) pure_install; \
	fi
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# perl-package -- the target generator macro for Perl packages
################################################################################

perl-package = $(call inner-perl-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-perl-package = $(call inner-perl-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
