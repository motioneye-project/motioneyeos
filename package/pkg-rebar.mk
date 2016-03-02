################################################################################
# rebar package infrastructure for Erlang packages
#
# This file implements an infrastructure that eases development of
# package .mk files for rebar packages.  It should be used for all
# packages that use rebar as their build system.
#
# In terms of implementation, this rebar infrastructure requires the
# .mk file to only specify metadata information about the package:
# name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default rebar behaviour. The
# package can also define some post operation hooks.
#
################################################################################

# Directories to store rebar dependencies in.
#
# These directories actually only contain symbolic links to Erlang
# applications in either $(HOST_DIR) or $(STAGING_DIR).  One needs
# them to avoid rebar complaining about missing dependencies, as this
# infrastructure tells rebar to NOT download dependencies during
# the build stage.
#
REBAR_HOST_DEPS_DIR = $(HOST_DIR)/usr/share/rebar/deps
REBAR_TARGET_DEPS_DIR = $(STAGING_DIR)/usr/share/rebar/deps

# Tell rebar where to find the dependencies
#
REBAR_HOST_DEPS_ENV = \
	ERL_COMPILER_OPTIONS='{i, "$(REBAR_HOST_DEPS_DIR)"}' \
	ERL_EI_LIBDIR=$(HOST_DIR)/usr/lib/erlang/lib/erl_interface-$(ERLANG_EI_VSN)/lib
REBAR_TARGET_DEPS_ENV = \
	ERL_COMPILER_OPTIONS='{i, "$(REBAR_TARGET_DEPS_DIR)"}' \
	ERL_EI_LIBDIR=$(STAGING_DIR)/usr/lib/erlang/lib/erl_interface-$(ERLANG_EI_VSN)/lib

################################################################################
# Helper functions
################################################################################

# Install an Erlang application from $(@D).
#
# i.e., define a recipe that installs the "bin ebin priv $(2)" directories
# from $(@D) to $(1)$($(PKG)_ERLANG_LIBDIR).
#
#  argument 1 should typically be $(HOST_DIR), $(TARGET_DIR),
#	      or $(STAGING_DIR).
#  argument 2 is typically empty when installing in $(TARGET_DIR) and
#             "include" when installing in $(HOST_DIR) or
#             $(STAGING_DIR).
#
# Note: calling this function must be done with $$(call ...) because it
# expands package-related variables.
#
define install-erlang-directories
	$(INSTALL) -d $(1)/$($(PKG)_ERLANG_LIBDIR)
	for dir in bin ebin priv $(2); do                               \
		if test -d $(@D)/$$dir; then                            \
			cp -r $(@D)/$$dir $(1)$($(PKG)_ERLANG_LIBDIR);  \
		fi;                                                     \
	done
endef

# Setup a symbolic link in rebar's deps_dir to the actual location
# where an Erlang application is installed.
#
# i.e., define a recipe that creates a symbolic link
# from $($(PKG)_REBAR_DEPS_DIR)/$($(PKG)_ERLANG_APP)
# to $(1)$($(PKG)_ERLANG_LIBDIR).
#
# For target packages for example, one uses this to setup symbolic
# links from $(STAGING_DIR)/usr/share/rebar/deps/<erlang-app> to
# $(STAGING_DIR)/usr/lib/erlang/lib/<erlang-app>-<version>. This
# infrastructure points rebar at the former in order to tell rebar to
# NOT download dependencies during the build stage, and instead use
# the already available dependencies.
#
# Therefore,
#  argument 1 is $(HOST_DIR) (for host packages) or
#	      $(STAGING_DIR) (for target packages).
#
#  argument 2 is HOST (for host packages) or
#	      TARGET (for target packages).
#
# Note: calling this function must be done with $$(call ...) because it
# expands package-related variables.
#
define install-rebar-deps
	$(INSTALL) -d $(REBAR_$(2)_DEPS_DIR)
	ln -f -s $(1)/$($(PKG)_ERLANG_LIBDIR) \
		$(REBAR_$(2)_DEPS_DIR)/$($(PKG)_ERLANG_APP)
endef

################################################################################
# inner-rebar-package -- defines how the configuration, compilation
# and installation of a rebar package should be done, implements a few
# hooks to tune the build process according to rebar specifities, and
# calls the generic package infrastructure to generate the necessary
# make targets.
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
#
################################################################################

define inner-rebar-package

# Extract just the raw package name, lowercase without the leading
# erlang- or host- prefix, as this is used by rebar to find the
# dependencies a package specifies.
#
$(2)_ERLANG_APP = $(subst -,_,$(patsubst erlang-%,%,$(patsubst host-%,%,$(1))))

# Path where to store the package's libs, relative to either $(HOST_DIR)
# for host packages, or $(STAGING_DIR) for target packages.
#
$(2)_ERLANG_LIBDIR = \
	/usr/lib/erlang/lib/$$($$(PKG)_ERLANG_APP)-$$($$(PKG)_VERSION)

# If a host package, inherit <pkg>_USE_BUNDLED_REBAR from the target
# package, if not explicitly defined. Otherwise, default to NO.
ifndef $(2)_USE_BUNDLED_REBAR
 ifdef $(3)_USE_BUNDLED_REBAR
  $(2)_USE_BUNDLED_REBAR = $$($(3)_USE_BUNDLED_REBAR)
 else
  $(2)_USE_BUNDLED_REBAR ?= NO
 endif
endif

# If a host package, inherit <pkg>_USE_AUTOCONF from the target
# package, if not explicitly defined. Otherwise, default to NO.
ifndef $(2)_USE_AUTOCONF
 ifdef $(3)_USE_AUTOCONF
  $(2)_USE_AUTOCONF = $$($(3)_USE_AUTOCONF)
 else
  $(2)_USE_AUTOCONF ?= NO
 endif
endif

# Define the build and install commands
#
ifeq ($(4),target)

# Target packages need the erlang interpreter on the target
$(2)_DEPENDENCIES += erlang

# Used only if the package uses autotools underneath; otherwise, ignored
$(2)_CONF_ENV += $$(REBAR_TARGET_DEPS_ENV)

ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$(@D); \
		CC="$$(TARGET_CC)" \
		CXX="$$(TARGET_CXX)" \
		CFLAGS="$$(TARGET_CFLAGS)" \
		CXXFLAGS="$$(TARGET_CXXFLAGS)" \
		LDFLAGS="$$(TARGET_LDFLAGS)" \
		$$(REBAR_TARGET_DEPS_ENV) \
		$$(TARGET_MAKE_ENV) \
		$$($$(PKG)_REBAR_ENV) $$($$(PKG)_REBAR) deps_dir=$$(REBAR_TARGET_DEPS_DIR) compile \
	)
endef
endif

# We need to double-$ the 'call' because it wants to expand
# package-related variables
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$$(call install-erlang-directories,$$(STAGING_DIR),include)
	$$(call install-rebar-deps,$$(STAGING_DIR),TARGET)
endef
endif

# We need to double-$ the 'call' because it wants to expand
# package-related variables
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$$(call install-erlang-directories,$$(TARGET_DIR))
endef
endif

else # !target

ifeq ($$($(2)_USE_AUTOCONF),YES)
# This must be repeated from inner-autotools-package, otherwise we get
# an empty _DEPENDENCIES if _AUTORECONF is YES or _USE_BUNDLED_REBAR
# is NO.  Also filter the result of _AUTORECONF and _GETTEXTIZE away
# from the non-host rule
$(2)_DEPENDENCIES ?= $$(filter-out host-automake host-autoconf host-libtool \
				host-gettext host-skeleton host-toolchain host-erlang-rebar $(1),\
    $$(patsubst host-host-%,host-%,$$(addprefix host-,$$($(3)_DEPENDENCIES))))
else
# Same deal, if _USE_BUNDLED_REBAR is NO.
$(2)_DEPENDENCIES ?= $$(filter-out  host-skeleton host-toolchain host-erlang-rebar $(1),\
	$$(patsubst host-host-%,host-%,$$(addprefix host-,$$($(3)_DEPENDENCIES))))
endif

# Host packages need the erlang interpreter on the host
$(2)_DEPENDENCIES += host-erlang

# Used only if the package uses autotools underneath; otherwise, ignored
$(2)_CONF_ENV += $$(REBAR_HOST_DEPS_ENV)

ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$(@D); \
		CC="$$(HOSTCC)" \
		CFLAGS="$$(HOST_CFLAGS)" \
		LDFLAGS="$$(HOST_LDFLAGS)" \
		$$(REBAR_HOST_DEPS_ENV) \
		$$(HOST_MAKE_ENV) \
		$$($$(PKG)_REBAR_ENV) $$($$(PKG)_REBAR) deps_dir=$$(REBAR_HOST_DEPS_DIR) compile \
	)
endef
endif

# We need to double-$ the 'call' because it wants to expand
# package-related variables
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	$$(call install-erlang-directories,$$(HOST_DIR),include)
	$$(call install-rebar-deps,$$(HOST_DIR),HOST)
endef
endif

endif # !target

# Whether to use the generic rebar or the package's bundled rebar
#
ifeq ($$($(2)_USE_BUNDLED_REBAR),YES)
$(2)_REBAR = ./rebar
else
$(2)_REBAR = rebar
$(2)_DEPENDENCIES += host-erlang-rebar
endif

# The package sub-infra to use
#
ifeq ($$($(2)_USE_AUTOCONF),YES)
$(call inner-autotools-package,$(1),$(2),$(3),$(4))
else
$(call inner-generic-package,$(1),$(2),$(3),$(4))
endif

endef # inner-rebar-package

rebar-package = $(call inner-rebar-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-rebar-package = $(call inner-rebar-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
