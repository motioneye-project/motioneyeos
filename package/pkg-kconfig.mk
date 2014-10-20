################################################################################
# Kconfig package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for packages that use kconfig for configuration files.
# It is based on the generic-package infrastructure, and inherits all of its
# features.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure.
#
################################################################################

################################################################################
# inner-kconfig-package -- generates the make targets needed to support a
# kconfig package
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-kconfig-package

# Call the generic package infrastructure to generate the necessary
# make targets.
# Note: this must be done _before_ attempting to use $$($(2)_DIR) in a
# dependency expression
$(call inner-generic-package,$(1),$(2),$(3),$(4))

# Default values
$(2)_KCONFIG_EDITORS ?= menuconfig
$(2)_KCONFIG_OPTS ?=
$(2)_KCONFIG_FIXUP_CMDS ?=

# FOO_KCONFIG_FILE is required
ifndef $(2)_KCONFIG_FILE
$$(error Internal error: no value specified for $(2)_KCONFIG_FILE)
endif

# The .config file is obtained by copying it from the specified source
# configuration file, after the package has been patched.
$$($(2)_DIR)/.config: $$($(2)_KCONFIG_FILE) | $(1)-patch
	$$(INSTALL) -m 0644 $$($(2)_KCONFIG_FILE) $$($(2)_DIR)/.config

# In order to get a usable, consistent configuration, some fixup may be needed.
# The exact rules are specified by the package .mk file.
$$($(2)_DIR)/.stamp_kconfig_fixup_done: $$($(2)_DIR)/.config
	$$($(2)_KCONFIG_FIXUP_CMDS)
	@yes "" | $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) oldconfig
	$$(Q)touch $$@

# Before running configure, the configuration file should be present and fixed
$$($(2)_TARGET_CONFIGURE): $$($(2)_DIR)/.stamp_kconfig_fixup_done

# Configuration editors (menuconfig, ...)
$$(addprefix $(1)-,$$($(2)_KCONFIG_EDITORS)): $$($(2)_DIR)/.stamp_kconfig_fixup_done
	$$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) $$(subst $(1)-,,$$@)
	rm -f $$($(2)_DIR)/.stamp_{kconfig_fixup_done,configured,built}
	rm -f $$($(2)_DIR)/.stamp_{target,staging}_installed

# Target to copy back the configuration to the source configuration file
$(1)-update-config: $$($(2)_DIR)/.stamp_kconfig_fixup_done
	cp --preserve=timestamps -f $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)

endef # inner-kconfig-package

################################################################################
# kconfig-package -- the target generator macro for kconfig packages
################################################################################

kconfig-package = $(call inner-kconfig-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
