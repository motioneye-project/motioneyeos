################################################################################
# Autotools package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for autotools packages. It should be used for all
# packages that use the autotools as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this autotools infrastructure requires
# the .mk file to only specify metadata informations about the
# package: name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default autotools behaviour. The
# package can also define some post operation hooks.
#
################################################################################


#
# Utility function to upgrade config.sub and config.guess files
#
# argument 1 : directory into which config.guess and config.sub need
# to be updated. Note that config.sub and config.guess are searched
# recursively in this directory.
#
define CONFIG_UPDATE
	for file in config.guess config.sub; do \
		for i in $$(find $(1) -name $$file); do \
			cp support/gnuconfig/$$file $$i; \
		done; \
	done
endef

################################################################################
# inner-autotools-package -- defines how the configuration, compilation and
# installation of an autotools package should be done, implements a
# few hooks to tune the build process for autotools specifities and
# calls the generic package infrastructure to generate the necessary
# make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including an HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the package directory prefix
#  argument 5 is the type (target or host)
################################################################################

define inner-autotools-package

ifndef $(2)_LIBTOOL_PATCH
 ifdef $(3)_LIBTOOL_PATCH
  $(2)_LIBTOOL_PATCH = $($(3)_LIBTOOL_PATCH)
 else
  $(2)_LIBTOOL_PATCH ?= YES
 endif
endif

ifndef $(2)_MAKE
 ifdef $(3)_MAKE
  $(2)_MAKE = $($(3)_MAKE)
 else
  $(2)_MAKE ?= $(MAKE)
 endif
endif

ifndef $(2)_AUTORECONF
 ifdef $(3)_AUTORECONF
  $(2)_AUTORECONF = $($(3)_AUTORECONF)
 else
  $(2)_AUTORECONF ?= NO
 endif
endif

$(2)_CONF_ENV			?=
$(2)_CONF_OPT			?=
$(2)_MAKE_ENV			?=
$(2)_MAKE_OPT			?=
$(2)_AUTORECONF_OPT		?= $($(3)_AUTORECONF_OPT)
$(2)_INSTALL_OPT                ?= install
$(2)_INSTALL_STAGING_OPT	?= DESTDIR=$$(STAGING_DIR) install
$(2)_INSTALL_TARGET_OPT		?= DESTDIR=$$(TARGET_DIR)  install
$(2)_CLEAN_OPT			?= clean
$(2)_UNINSTALL_STAGING_OPT	?= DESTDIR=$$(STAGING_DIR) uninstall
$(2)_UNINSTALL_TARGET_OPT	?= DESTDIR=$$(TARGET_DIR)  uninstall


#
# Configure step. Only define it if not already defined by the package
# .mk file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_CONFIGURE_CMDS
ifeq ($(5),target)

# Configure package for target
define $(2)_CONFIGURE_CMDS
	(cd $$($$(PKG)_SRCDIR) && rm -rf config.cache && \
	$$(TARGET_CONFIGURE_OPTS) \
	$$(TARGET_CONFIGURE_ARGS) \
	$$($$(PKG)_CONF_ENV) \
	./configure \
		--target=$$(GNU_TARGET_NAME) \
		--host=$$(GNU_TARGET_NAME) \
		--build=$$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--program-prefix="" \
		$$(DISABLE_DOCUMENTATION) \
		$$(DISABLE_NLS) \
		$$(DISABLE_LARGEFILE) \
		$$(DISABLE_IPV6) \
		$$(SHARED_STATIC_LIBS_OPTS) \
		$$(QUIET) $$($$(PKG)_CONF_OPT) \
	)
endef
else

# Configure package for host
# disable all kind of documentation generation in the process,
# because it often relies on host tools which may or may not be
# installed.
define $(2)_CONFIGURE_CMDS
	(cd $$($$(PKG)_SRCDIR) && rm -rf config.cache; \
	        $$(HOST_CONFIGURE_OPTS) \
		CFLAGS="$$(HOST_CFLAGS)" \
		LDFLAGS="$$(HOST_LDFLAGS)" \
                $$($$(PKG)_CONF_ENV) \
		./configure \
		--prefix="$$(HOST_DIR)/usr" \
		--sysconfdir="$$(HOST_DIR)/etc" \
		--enable-shared --disable-static \
		--disable-gtk-doc \
		--disable-doc \
		--disable-docs \
		--disable-documentation \
		--with-xmlto=no \
		--with-fop=no \
		$$(QUIET) $$($$(PKG)_CONF_OPT) \
	)
endef
endif
endif

#
# Hook to update config.sub and config.guess if needed
#
define UPDATE_CONFIG_HOOK
       @$$(call MESSAGE,"Updating config.sub and config.guess")
       $$(call CONFIG_UPDATE,$$(@D))
endef

$(2)_POST_PATCH_HOOKS += UPDATE_CONFIG_HOOK

#
# Hook to patch libtool to make it work properly for cross-compilation
#
define LIBTOOL_PATCH_HOOK
	@$$(call MESSAGE,"Patching libtool")
	$(Q)if test "$$($$(PKG)_LIBTOOL_PATCH)" = "YES" \
		-a "$$($$(PKG)_AUTORECONF)" != "YES"; then \
		for i in `find $$($$(PKG)_SRCDIR) -name ltmain.sh`; do \
			ltmain_version=`sed -n '/^[ 	]*VERSION=/{s/^[ 	]*VERSION=//;p;q;}' $$$$i | \
			sed -e 's/\([0-9].[0-9]*\).*/\1/' -e 's/\"//'`; \
			if test $$$${ltmain_version} = '1.5'; then \
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v1.5.patch; \
			elif test $$$${ltmain_version} = "2.2"; then\
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v2.2.patch; \
			elif test $$$${ltmain_version} = "2.4"; then\
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v2.4.patch; \
			fi \
		done \
	fi
endef

# default values are not evaluated yet, so don't rely on this defaulting to YES
ifneq ($$($(2)_LIBTOOL_PATCH),NO)
$(2)_POST_PATCH_HOOKS += LIBTOOL_PATCH_HOOK
endif

#
# Hook to autoreconf the package if needed
#
define AUTORECONF_HOOK
	@$$(call MESSAGE,"Autoreconfiguring")
	$(Q)cd $$($$(PKG)_SRCDIR) && $(AUTORECONF) $$($$(PKG)_AUTORECONF_OPT)
	$(Q)if test "$$($$(PKG)_LIBTOOL_PATCH)" = "YES"; then \
		for i in `find $$($$(PKG)_SRCDIR) -name ltmain.sh`; do \
			ltmain_version=`sed -n '/^[ 	]*VERSION=/{s/^[ 	]*VERSION=//;p;q;}' $$$$i | \
			sed -e 's/\([0-9].[0-9]*\).*/\1/' -e 's/\"//'`; \
			if test $$$${ltmain_version} = "1.5"; then \
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v1.5.patch; \
			elif test $$$${ltmain_version} = "2.2"; then\
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v2.2.patch; \
			elif test $$$${ltmain_version} = "2.4"; then\
				support/scripts/apply-patches.sh $$$${i%/*} support/libtool buildroot-libtool-v2.4.patch; \
			fi \
		done \
	fi
endef

# This must be repeated from inner-generic-package, otherwise we get an empty
# _DEPENDENCIES if _AUTORECONF is YES.  Also filter the result of _AUTORECONF
# away from the non-host rule
$(2)_DEPENDENCIES ?= $(filter-out host-automake host-autoconf host-libtool $(1),\
    $(patsubst host-host-%,host-%,$(addprefix host-,$($(3)_DEPENDENCIES))))


ifeq ($$($(2)_AUTORECONF),YES)
$(2)_PRE_CONFIGURE_HOOKS += AUTORECONF_HOOK
$(2)_DEPENDENCIES += host-automake host-autoconf host-libtool
endif

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
ifeq ($(5),target)
define $(2)_BUILD_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) -C $$($$(PKG)_SRCDIR)
endef
else
define $(2)_BUILD_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_MAKE_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_INSTALL_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_INSTALL_STAGING_OPT) -C $$($$(PKG)_SRCDIR)
	for i in $$$$(find $(STAGING_DIR)/usr/lib* -name "*.la"); do \
		cp -f $$$$i $$$$i~; \
		$$(SED) "s:\(['= ]\)/usr:\\1$(STAGING_DIR)/usr:g" $$$$i; \
	done
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_INSTALL_TARGET_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif

#
# Clean step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_CLEAN_CMDS
define $(2)_CLEAN_CMDS
	-$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE)  $$($$(PKG)_CLEAN_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif

#
# Uninstall from staging step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_UNINSTALL_STAGING_CMDS
define $(2)_UNINSTALL_STAGING_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) $$($$(PKG)_UNINSTALL_STAGING_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif

#
# Uninstall from target step. Only define it if not already defined
# by the package .mk file.
# Autotools Makefiles do uninstall with ( cd ...; rm -f ... )
# Since we remove a lot of directories in target-finalize, this is likely
# to fail.  Therefore add -k flag.
#
ifndef $(2)_UNINSTALL_TARGET_CMDS
define $(2)_UNINSTALL_TARGET_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_MAKE_ENV) $$($$(PKG)_MAKE) -k $$($$(PKG)_UNINSTALL_TARGET_OPT) -C $$($$(PKG)_SRCDIR)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4),$(5))

endef

################################################################################
# autotools-package -- the target generator macro for autotools packages
################################################################################

autotools-package = $(call inner-autotools-package,$(call pkgname),$(call UPPERCASE,$(call pkgname)),$(call UPPERCASE,$(call pkgname)),$(call pkgparentdir),target)
host-autotools-package = $(call inner-autotools-package,host-$(call pkgname),$(call UPPERCASE,host-$(call pkgname)),$(call UPPERCASE,$(call pkgname)),$(call pkgparentdir),host)
