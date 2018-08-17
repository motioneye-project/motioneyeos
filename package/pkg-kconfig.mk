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

# Macro to update back the custom (def)config file
# $(1): file to copy from
define kconfig-package-update-config
	@$(if $($(PKG)_KCONFIG_FRAGMENT_FILES), \
		echo "Unable to perform $(@) when fragment files are set"; exit 1)
	@$(if $($(PKG)_KCONFIG_DEFCONFIG), \
		echo "Unable to perform $(@) when using a defconfig rule"; exit 1)
	$(Q)if [ -d $($(PKG)_KCONFIG_FILE) ]; then \
		echo "Unable to perform $(@) when $($(PKG)_KCONFIG_FILE) is a directory"; \
		exit 1; \
	fi
	$(Q)mkdir -p $(dir $($(PKG)_KCONFIG_FILE))
	cp -f $($(PKG)_DIR)/$(1) $($(PKG)_KCONFIG_FILE)
	$(Q)touch --reference $($(PKG)_DIR)/$($(PKG)_KCONFIG_DOTCONFIG) $($(PKG)_KCONFIG_FILE)
endef

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

# Register the kconfig dependencies as regular dependencies, so that
# they are also accounted for in the generated graphs.
$(2)_DEPENDENCIES += $$($(2)_KCONFIG_DEPENDENCIES)

# Call the generic package infrastructure to generate the necessary
# make targets.
# Note: this must be done _before_ attempting to use $$($(2)_DIR) in a
# dependency expression
$(call inner-generic-package,$(1),$(2),$(3),$(4))

# Default values
$(2)_KCONFIG_EDITORS ?= menuconfig
$(2)_KCONFIG_OPTS ?=
$(2)_KCONFIG_FIXUP_CMDS ?=
$(2)_KCONFIG_FRAGMENT_FILES ?=
$(2)_KCONFIG_DOTCONFIG ?= .config

# The config file as well as the fragments could be in-tree, so before
# depending on them the package should be extracted (and patched) first.
#
# Since those files only have a order-only dependency, make would treat
# any missing one as a "force" target:
#   https://www.gnu.org/software/make/manual/make.html#Force-Targets
# and would forcibly any rule that depend on those files, causing a
# rebuild of the kernel each time make is called.
#
# So, we provide a recipe that checks all of those files exist, to
# overcome that standard make behaviour.
#
$$($(2)_KCONFIG_FILE) $$($(2)_KCONFIG_FRAGMENT_FILES): | $(1)-patch
	for f in $$($(2)_KCONFIG_FILE) $$($(2)_KCONFIG_FRAGMENT_FILES); do \
		if [ ! -f "$$$${f}" ]; then \
			printf "Kconfig fragment '%s' for '%s' does not exist\n" "$$$${f}" "$(1)"; \
			exit 1; \
		fi; \
	done

$(2)_KCONFIG_MAKE = \
	$$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) $$($(2)_KCONFIG_OPTS)

# $(2)_KCONFIG_MAKE may already rely on shell expansion. As the $() syntax
# of the shell conflicts with Make's own syntax, this means that backticks
# are used with those shell constructs. Unfortunately, the backtick syntax
# does not nest, and we need to use Make instead of the shell to handle
# conditions.

# A recursively expanded variable is necessary, to be sure that the shell
# command is called when the rule is processed during the build and not
# when the rule is created when parsing all packages.
$(2)_KCONFIG_RULES = \
	$$(shell $$($(2)_KCONFIG_MAKE) -pn config 2>/dev/null | \
		sed 's/^\([_0-9a-zA-Z]*config\):.*/\1/ p; d')

# The correct way to regenerate a .config file is to use 'make olddefconfig'.
# For historical reasons, the target name is 'oldnoconfig' between Linux kernel
# versions 2.6.36 and 3.6, and remains as an alias in later versions.
# In older versions, and in some other projects that use kconfig, the target is
# not supported at all, and we use 'yes "" | make oldconfig' as a fallback
# only, as this can fail in complex cases.
define $(2)_REGEN_DOT_CONFIG
	$$(if $$(filter olddefconfig,$$($(2)_KCONFIG_RULES)),
		$$(Q)$$($(2)_KCONFIG_MAKE) olddefconfig,
		$$(if $$(filter oldnoconfig,$$($(2)_KCONFIG_RULES)),
			$$(Q)$$($(2)_KCONFIG_MAKE) oldnoconfig,
			$$(Q)(yes "" | $$($(2)_KCONFIG_MAKE) oldconfig)))
endef

# The specified source configuration file and any additional configuration file
# fragments are merged together to .config, after the package has been patched.
# Since the file could be a defconfig file it needs to be expanded to a
# full .config first.
$$($(2)_DIR)/$$($(2)_KCONFIG_DOTCONFIG): $$($(2)_KCONFIG_FILE) $$($(2)_KCONFIG_FRAGMENT_FILES)
	$$(Q)$$(if $$($(2)_KCONFIG_DEFCONFIG), \
		$$($(2)_KCONFIG_MAKE) $$($(2)_KCONFIG_DEFCONFIG), \
		$$(INSTALL) -m 0644 -D $$($(2)_KCONFIG_FILE) $$(@))
	$$(Q)support/kconfig/merge_config.sh -m -O $$(@D) \
		$$(@) $$($(2)_KCONFIG_FRAGMENT_FILES)
	$$($(2)_REGEN_DOT_CONFIG)

# If _KCONFIG_FILE or _KCONFIG_FRAGMENT_FILES exists, this dependency is
# already implied, but if we only have a _KCONFIG_DEFCONFIG we have to add
# it explicitly. It doesn't hurt to always have it though.
$$($(2)_DIR)/$$($(2)_KCONFIG_DOTCONFIG): | $(1)-patch

# Some packages may need additional tools to be present by the time their
# kconfig structure is parsed (e.g. the linux kernel may need to call to
# the compiler to test its features).
$$($(2)_DIR)/$$($(2)_KCONFIG_DOTCONFIG): | $$($(2)_KCONFIG_DEPENDENCIES)

# In order to get a usable, consistent configuration, some fixup may be needed.
# The exact rules are specified by the package .mk file.
define $(2)_FIXUP_DOT_CONFIG
	$$($(2)_KCONFIG_FIXUP_CMDS)
	$$($(2)_REGEN_DOT_CONFIG)
	$$(Q)touch $$($(2)_DIR)/.stamp_kconfig_fixup_done
endef

$$($(2)_DIR)/.stamp_kconfig_fixup_done: $$($(2)_DIR)/$$($(2)_KCONFIG_DOTCONFIG)
	$$($(2)_FIXUP_DOT_CONFIG)

# Before running configure, the configuration file should be present and fixed
$$($(2)_TARGET_CONFIGURE): $$($(2)_DIR)/.stamp_kconfig_fixup_done

# Force olddefconfig again on -reconfigure
$(1)-clean-for-reconfigure: $(1)-clean-kconfig-for-reconfigure

$(1)-clean-kconfig-for-reconfigure:
	rm -f $$($(2)_DIR)/.stamp_kconfig_fixup_done

# Only enable the foo-*config targets when the package is actually enabled.
# Note: the variable $(2)_KCONFIG_VAR is not related to the kconfig
# infrastructure, but defined by pkg-generic.mk. The generic infrastructure is
# already called above, so we can effectively use this variable.
ifeq ($$($$($(2)_KCONFIG_VAR)),y)

ifeq ($$(BR_BUILDING),y)
# Either FOO_KCONFIG_FILE or FOO_KCONFIG_DEFCONFIG is required...
ifeq ($$(or $$($(2)_KCONFIG_FILE),$$($(2)_KCONFIG_DEFCONFIG)),)
$$(error Internal error: no value specified for $(2)_KCONFIG_FILE or $(2)_KCONFIG_DEFCONFIG)
endif
# ... but not both:
ifneq ($$(and $$($(2)_KCONFIG_FILE),$$($(2)_KCONFIG_DEFCONFIG)),)
$$(error Internal error: $(2)_KCONFIG_FILE and $(2)_KCONFIG_DEFCONFIG are mutually exclusive but both are defined)
endif
endif

# For the configurators, we do want to use the system-provided host
# tools, not the ones we build. This is particularly true for
# pkg-config; if we use our pkg-config (from host-pkgconf), then it
# would not look for the .pc from the host, but we do need them,
# especially to find ncurses, GTK+, Qt (resp. for menuconfig and
# nconfig, gconfig, xconfig).
# So we simply remove our PATH and PKG_CONFIG_* variables.
$(2)_CONFIGURATOR_MAKE_ENV = \
	$$(filter-out PATH=% PKG_CONFIG=% PKG_CONFIG_SYSROOT_DIR=% PKG_CONFIG_LIBDIR=%,$$($(2)_MAKE_ENV)) \
	PKG_CONFIG_PATH="$(HOST_PKG_CONFIG_PATH)"

# Configuration editors (menuconfig, ...)
#
# We need to apply the configuration fixups right after a configuration
# editor exits, so that it is possible to save the configuration right
# after exiting an editor, and so the user always sees a .config file
# that is clean wrt. our requirements.
#
# Because commands in $(1)_FIXUP_KCONFIG are probably using $(@D), we
# need to have a valid @D set. But, because the configurators rules are
# not real files and do not contain the path to the package build dir,
# @D would be just '.' in this case. So, we use an intermediate rule
# with a stamp-like file which path is in the package build dir, so we
# end up having a valid @D.
#
$$(addprefix $(1)-,$$($(2)_KCONFIG_EDITORS)): $(1)-%: $$($(2)_DIR)/.kconfig_editor_%
$$($(2)_DIR)/.kconfig_editor_%: $$($(2)_DIR)/.stamp_kconfig_fixup_done
	$$($(2)_CONFIGURATOR_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) $$(*)
	rm -f $$($(2)_DIR)/.stamp_{kconfig_fixup_done,configured,built}
	rm -f $$($(2)_DIR)/.stamp_{target,staging,images}_installed
	$$($(2)_FIXUP_DOT_CONFIG)

# Saving back the configuration
#
# Ideally, that should directly depend on $$($(2)_DIR)/.stamp_kconfig_fixup_done,
# but that breaks the use-case in PR-8156 (from a clean tree):
#   make menuconfig           <- enable kernel, use an in-tree defconfig, save and exit
#   make linux-menuconfig     <- enable/disable whatever option, save and exit
#   make menuconfig           <- change to use a custom defconfig file, set a path, save and exit
#   make linux-update-config  <- should save to the new custom defconfig file
#
# Because of that use-case, saving the configuration can *not* directly
# depend on the stamp file, because it itself depends on the .config,
# which in turn depends on the (newly-set an non-existent) custom
# defconfig file.
#
# Instead, we use a PHONY rule that will catch that situation.
#
$(1)-check-configuration-done:
	@if [ ! -f $$($(2)_DIR)/.stamp_kconfig_fixup_done ]; then \
		echo "$(1) is not yet configured"; \
		exit 1; \
	fi

$(1)-savedefconfig: $(1)-check-configuration-done
	$$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_DIR) \
		$$($(2)_KCONFIG_OPTS) savedefconfig

# Target to copy back the configuration to the source configuration file
# Even though we could use 'cp --preserve-timestamps' here, the separate
# cp and 'touch --reference' is used for symmetry with $(1)-update-defconfig.
$(1)-update-config: PKG=$(2)
$(1)-update-config: $(1)-check-configuration-done
	$$(call kconfig-package-update-config,$$($(2)_KCONFIG_DOTCONFIG))

# Note: make sure the timestamp of the stored configuration is not newer than
# the .config to avoid a useless rebuild. Note that, contrary to
# $(1)-update-config, the reference for 'touch' is _not_ the file from which
# we copy.
$(1)-update-defconfig: PKG=$(2)
$(1)-update-defconfig: $(1)-savedefconfig
	$$(call kconfig-package-update-config,defconfig)

endif # package enabled

.PHONY: \
	$(1)-update-config \
	$(1)-update-defconfig \
	$(1)-savedefconfig \
	$(1)-check-configuration-done \
	$$($(2)_DIR)/.kconfig_editor_% \
	$$(addprefix $(1)-,$$($(2)_KCONFIG_EDITORS))

endef # inner-kconfig-package

################################################################################
# kconfig-package -- the target generator macro for kconfig packages
################################################################################

kconfig-package = $(call inner-kconfig-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
