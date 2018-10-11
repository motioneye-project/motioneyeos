################################################################################
# WAF package infrastructure
#
# This file implements an infrastructure that eases development of package
# .mk files for WAF packages. It should be used for all packages that use
# WAF as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this WAF infrastructure requires the .mk file
# to only specify metadata information about the package: name, version,
# download URL, etc.
#
# We still allow the package .mk file to override what the different steps
# are doing, if needed. For example, if <PKG>_BUILD_CMDS is already defined,
# it is used as the list of commands to perform to build the package,
# instead of the default WAF behaviour. The package can also define some
# post operation hooks.
#
################################################################################

################################################################################
# inner-waf-package -- defines how the configuration, compilation and
# installation of a waf package should be done, implements a few hooks
# to tune the build process for waf specifities and calls the generic
# package infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-waf-package

# We need host-python to run waf
$(2)_DEPENDENCIES += host-python

$(2)_NEEDS_EXTERNAL_WAF ?= NO

# If the package does not have its own waf, use our own.
ifeq ($$($(2)_NEEDS_EXTERNAL_WAF),YES)
$(2)_DEPENDENCIES += host-waf
$(2)_WAF = $$(HOST_DIR)/bin/waf
else
$(2)_WAF = ./waf
endif

$(2)_BUILD_OPTS				?=
$(2)_INSTALL_STAGING_OPTS		?=
$(2)_INSTALL_TARGET_OPTS		?=
$(2)_WAF_OPTS				?=

#
# Configure step. Only define it if not already defined by the package
# .mk file.
#
ifndef $(2)_CONFIGURE_CMDS
define $(2)_CONFIGURE_CMDS
	cd $$($$(PKG)_SRCDIR) && \
	$$(TARGET_CONFIGURE_OPTS) \
	$$($(2)_CONF_ENV) \
	$$(HOST_DIR)/bin/python2 $$($(2)_WAF) configure \
		--prefix=/usr \
		--libdir=/usr/lib \
		$$($(2)_CONF_OPTS) \
		$$($(2)_WAF_OPTS)
endef
endif

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	cd $$($$(PKG)_SRCDIR) && \
	$$(TARGET_MAKE_ENV) $$(HOST_DIR)/bin/python2 $$($(2)_WAF) \
		build -j $$(PARALLEL_JOBS) $$($(2)_BUILD_OPTS) \
		$$($(2)_WAF_OPTS)
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	cd $$($$(PKG)_SRCDIR) && \
	$$(TARGET_MAKE_ENV) $$(HOST_DIR)/bin/python2 $$($(2)_WAF) \
		install --destdir=$$(STAGING_DIR) \
		$$($(2)_INSTALL_STAGING_OPTS) \
		$$($(2)_WAF_OPTS)
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	cd $$($$(PKG)_SRCDIR) && \
	$$(TARGET_MAKE_ENV) $$(HOST_DIR)/bin/python2 $$($(2)_WAF) \
		install --destdir=$$(TARGET_DIR) \
		$$($(2)_INSTALL_TARGET_OPTS) \
		$$($(2)_WAF_OPTS)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# waf-package -- the target generator macro for WAF packages
################################################################################

waf-package = $(call inner-waf-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
