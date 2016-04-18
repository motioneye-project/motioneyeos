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
$(2)_KCONFIG_FRAGMENT_FILES ?=

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

# The specified source configuration file and any additional configuration file
# fragments are merged together to .config, after the package has been patched.
# Since the file could be a defconfig file it needs to be expanded to a
# full .config first. We use 'make oldconfig' because this can be safely
# done even when the package does not support defconfigs.
$$($(2)_DIR)/.config: $$($(2)_KCONFIG_FILE) $$($(2)_KCONFIG_FRAGMENT_FILES)
	$$(Q)$$(if $$($(2)_KCONFIG_DEFCONFIG), \
		$$($(2)_KCONFIG_MAKE) $$($(2)_KCONFIG_DEFCONFIG), \
		cp $$($(2)_KCONFIG_FILE) $$(@))
	$$(Q)support/kconfig/merge_config.sh -m -O $$(@D) \
		$$(@) $$($(2)_KCONFIG_FRAGMENT_FILES)
	$$(Q)yes "" | $$($(2)_KCONFIG_MAKE) oldconfig

# If _KCONFIG_FILE or _KCONFIG_FRAGMENT_FILES exists, this dependency is
# already implied, but if we only have a _KCONFIG_DEFCONFIG we have to add
# it explicitly. It doesn't hurt to always have it though.
$$($(2)_DIR)/.config: | $(1)-patch

# In order to get a usable, consistent configuration, some fixup may be needed.
# The exact rules are specified by the package .mk file.
define $(2)_FIXUP_DOT_CONFIG
	$$($(2)_KCONFIG_FIXUP_CMDS)
	$$(Q)yes "" | $$($(2)_KCONFIG_MAKE) oldconfig
	$$(Q)touch $$($(2)_DIR)/.stamp_kconfig_fixup_done
endef

$$($(2)_DIR)/.stamp_kconfig_fixup_done: $$($(2)_DIR)/.config
	$$($(2)_FIXUP_DOT_CONFIG)

# Before running configure, the configuration file should be present and fixed
$$($(2)_TARGET_CONFIGURE): $$($(2)_DIR)/.stamp_kconfig_fixup_done

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
	$$(filter-out PATH=% PKG_CONFIG=% PKG_CONFIG_SYSROOT_DIR=% PKG_CONFIG_LIBDIR=%,$$($(2)_MAKE_ENV))

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
# Instead, we use an PHONY rule that will catch that situation.
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
$(1)-update-config: $(1)-check-configuration-done
	@$$(if $$($(2)_KCONFIG_FRAGMENT_FILES), \
		echo "Unable to perform $(1)-update-config when fragment files are set"; exit 1)
	@$$(if $$($(2)_KCONFIG_DEFCONFIG), \
		echo "Unable to perform $(1)-update-config when using a defconfig rule"; exit 1)
	cp -f $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)
	touch --reference $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)

# Note: make sure the timestamp of the stored configuration is not newer than
# the .config to avoid a useless rebuild. Note that, contrary to
# $(1)-update-config, the reference for 'touch' is _not_ the file from which
# we copy.
$(1)-update-defconfig: $(1)-savedefconfig
	@$$(if $$($(2)_KCONFIG_FRAGMENT_FILES), \
		echo "Unable to perform $(1)-update-defconfig when fragment files are set"; exit 1)
	@$$(if $$($(2)_KCONFIG_DEFCONFIG), \
		echo "Unable to perform $(1)-update-defconfig when using a defconfig rule"; exit 1)
	cp -f $$($(2)_DIR)/defconfig $$($(2)_KCONFIG_FILE)
	touch --reference $$($(2)_DIR)/.config $$($(2)_KCONFIG_FILE)

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
