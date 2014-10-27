################################################################################
# LuaRocks package infrastructure
# see http://luarocks.org/
#
# This file implements an infrastructure that eases development of
# package .mk files for LuaRocks packages.
# LuaRocks supports various build.type : builtin, make, cmake.
# This luarocks infrastructure supports only the builtin mode,
# the make & cmake modes could be directly handled by generic & cmake infrastructure.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this LuaRocks infrastructure requires
# the .mk file to only specify metadata information about the
# package: name, version, etc.
#
################################################################################

################################################################################
# inner-luarocks-package -- defines how the configuration, compilation and
# installation of a LuaRocks package should be done, implements a few hooks to
# tune the build process and calls the generic package infrastructure to
# generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-luarocks-package

$(2)_BUILD_OPTS		?=
$(2)_SUBDIR		?= $(1)-$$(shell echo "$$($(3)_VERSION)" | sed -e "s/-[0-9]$$$$//")
$(2)_ROCKSPEC		?= $(1)-$$($(3)_VERSION).rockspec
$(2)_SOURCE		?= $(1)-$$($(3)_VERSION).src.rock
$(2)_SITE		?= $$(call qstrip,$$(BR2_LUAROCKS_MIRROR))

# Since we do not support host-luarocks-package, we know this is
# a target package, and can just add the required dependencies
$(2)_DEPENDENCIES	+= host-luarocks luainterpreter

#
# Extract step
#
ifndef $(2)_EXTRACT_CMDS
define $(2)_EXTRACT_CMDS
	cd $$($(2)_DIR)/.. && \
		$$(LUAROCKS_RUN) unpack --force $$(DL_DIR)/$$($(2)_SOURCE)
endef
endif

#
# Build/install step.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	cd $$($(2)_SRCDIR) && \
		$$(LUAROCKS_RUN) make --keep $$($(2)_ROCKSPEC) $$($(2)_BUILD_OPTS)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

# $(2)_DEPENDENCIES are handled for configure step (too late)
# but host-luarocks is required to do the extract
$$($(2)_TARGET_EXTRACT): | host-luarocks

endef

################################################################################
# luarocks-package -- the target generator macro for LuaRocks packages
################################################################################

luarocks-package = $(call inner-luarocks-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
# host-luarocks-package not supported
