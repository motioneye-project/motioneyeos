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

# The config file could be in-tree, so before depending on it the package should
# be extracted (and patched) first
$$($(2)_KCONFIG_FILE): | $(1)-patch

# The .config file is obtained by copying it from the specified source
# configuration file, after the package has been patched.
# Since the file could be a defconfig file it needs to be expanded to a
# full .config first. We use 'make oldconfig' because this can be safely
# done even when the package does not support defconfigs.
$$($(2)_DIR)/.config: $$($(2)_KCONFIG_FILE)
	$$(INSTALL) -m 0644 $$($(2)_KCONFIG_FILE) $$($(2)_DIR)/.config
	@yes "" | $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) oldconfig

# In order to get a usable, consistent configuration, some fixup may be needed.
# The exact rules are specified by the package .mk file.
$$($(2)_DIR)/.stamp_kconfig_fixup_done: $$($(2)_DIR)/.config
	$$($(2)_KCONFIG_FIXUP_CMDS)
	@yes "" | $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) oldconfig
	$$(Q)touch $$@

# Before running configure, the configuration file should be present and fixed
$$($(2)_TARGET_CONFIGURE): $$($(2)_DIR)/.stamp_kconfig_fixup_done

# Only enable the foo-*config targets when the package is actually enabled.
# Note: the variable $(2)_KCONFIG_VAR is not related to the kconfig
# infrastructure, but defined by pkg-generic.mk. The generic infrastructure is
# already called above, so we can effectively use this variable.
ifeq ($$($$($(2)_KCONFIG_VAR)),y)

# Configuration editors (menuconfig, ...)
$$(addprefix $(1)-,$$($(2)_KCONFIG_EDITORS)): $$($(2)_DIR)/.stamp_kconfig_fixup_done
	$$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) $$(subst $(1)-,,$$@)
	rm -f $$($(2)_DIR)/.stamp_{kconfig_fixup_done,configured,built}
	rm -f $$($(2)_DIR)/.stamp_{target,staging,images}_installed

$(1)-savedefconfig: $$($(2)_DIR)/.stamp_kconfig_fixup_done
	$$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) savedefconfig

# Target to copy back the configuration to the source configuration file
# Even though we could use 'cp --preserve-timestamps' here, the separate
# cp and 'touch --reference' is used for symmetry with $(1)-update-defconfig.
$(1)-update-config: $$($(2)_DIR)/.stamp_kconfig_fixup_done
	cp -f $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)
	touch --reference $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)

# Note: make sure the timestamp of the stored configuration is not newer than
# the .config to avoid a useless rebuild. Note that, contrary to
# $(1)-update-config, the reference for 'touch' is _not_ the file from which
# we copy.
$(1)-update-defconfig: $(1)-savedefconfig
	cp -f $$($(2)_DIR)/defconfig $$($(2)_KCONFIG_FILE)
	touch --reference $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)

endif # package enabled

endef # inner-kconfig-package

################################################################################
# kconfig-package -- the target generator macro for kconfig packages
################################################################################

kconfig-package = $(call inner-kconfig-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
