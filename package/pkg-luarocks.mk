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

LUAROCKS_RUN_CMD = $(HOST_DIR)/bin/luarocks
LUAROCKS_CFLAGS = $(TARGET_CFLAGS) -fPIC
ifeq ($(BR2_PACKAGE_LUA_5_3),y)
LUAROCKS_CFLAGS += -DLUA_COMPAT_5_2
endif

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
$(2)_NAME_UPSTREAM	?= $(1)
$(2)_SUBDIR		?= $$($(2)_NAME_UPSTREAM)-$$(shell echo "$$($(2)_VERSION)" | sed -e "s/-[0-9]$$$$//")
$(2)_ROCKSPEC		?= $$(call LOWERCASE,$$($(2)_NAME_UPSTREAM))-$$($(2)_VERSION).rockspec
$(2)_SOURCE		?= $$(call LOWERCASE,$$($(2)_NAME_UPSTREAM))-$$($(2)_VERSION).src.rock
$(2)_SITE		?= $$(call qstrip,$$(BR2_LUAROCKS_MIRROR))

# Since we do not support host-luarocks-package, we know this is
# a target package, and can just add the required dependencies
$(2)_DEPENDENCIES	+= luainterpreter
$(2)_EXTRACT_DEPENDENCIES += host-luarocks

#
# Extract step. Extract into a temporary dir and move the relevant part to the
# source dir.
#
ifndef $(2)_EXTRACT_CMDS
define $(2)_EXTRACT_CMDS
	mkdir -p $$($(2)_DIR)/luarocks-extract
	cd $$($(2)_DIR)/luarocks-extract && \
		$$(LUAROCKS_RUN_CMD) unpack --force $$($(2)_DL_DIR)/$$($(2)_SOURCE)
	mv $$($(2)_DIR)/luarocks-extract/*/* $$($(2)_DIR)
endef
endif

#
# Build/install step.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	cd $$($(2)_SRCDIR) && \
		LUAROCKS_CONFIG=$$(LUAROCKS_CONFIG_FILE) \
		$$(LUAROCKS_RUN_CMD) make --keep --deps-mode none \
			--tree "$$(TARGET_DIR)/usr" \
			LUA_INCDIR="$$(STAGING_DIR)/usr/include" \
			LUA_LIBDIR="$$(STAGING_DIR)/usr/lib" \
			CC=$$(TARGET_CC) \
			LD=$$(TARGET_CC) \
			CFLAGS="$$(LUAROCKS_CFLAGS)" \
			LIBFLAG="-shared $$(TARGET_LDFLAGS)" \
			$$($(2)_BUILD_OPTS) $$($(2)_ROCKSPEC)
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

# Upgrade helper
$(1)-upgrade: host-luarocks
	$$(LUAROCKS_RUN_CMD) buildroot $$($(2)_NAME_UPSTREAM) $(1)

.PHONY: $(1)-upgrade

endef

################################################################################
# luarocks-package -- the target generator macro for LuaRocks packages
################################################################################

luarocks-package = $(call inner-luarocks-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
# host-luarocks-package not supported
