################################################################################
# kernel module infrastructure for building Linux kernel modules
#
# This file implements an infrastructure that eases development of package
# .mk files for out-of-tree Linux kernel modules. It should be used for all
# packages that build a Linux kernel module using the kernel's out-of-tree
# buildsystem, unless they use a complex custom buildsystem.
#
# The kernel-module infrastructure requires the packages that use it to also
# use another package infrastructure. kernel-module only defines post-build
# and post-install hooks. This allows the package to build both kernel
# modules and/or user-space components (with any of the other *-package
# infra).
#
# As such, it is to be used in conjunction with another *-package infra,
# like so:
#
#   $(eval $(kernel-module))
#   $(eval $(generic-package))
#
# Note: if the caller needs access to the kernel modules (either after they
# are built or after they are installed), it will have to define its own
# post-build/install hooks *after* calling kernel-module, but *before*
# calling the other *-package infra, like so:
#
#   $(eval $(kernel-module))
#   define FOO_MOD_TWEAK
#       # do something
#   endef
#   FOO_POST_BUILD_HOOKS += FOO_MOD_TWEAK
#   $(eval $(generic-package))
#
# Note: this infra does not check that the kernel is enabled; it is expected
# to be enforced at the Kconfig level with proper 'depends on'.
################################################################################

################################################################################
# inner-kernel-module -- generates the make targets needed to support building
# a kernel module
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name
################################################################################

define inner-kernel-module

# If the package is enabled, ensure the kernel will support modules
ifeq ($$(BR2_PACKAGE_$(2)),y)
LINUX_NEEDS_MODULES = y
endif

# The kernel must be built first.
$(2)_DEPENDENCIES += linux

# This is only defined in some infrastructures (e.g. autotools, cmake),
# but not in others (e.g. generic). So define it here as well.
$(2)_MAKE ?= $$(MAKE)

# If not specified, consider the source of the kernel module to be at
# the root of the package.
$(2)_MODULE_SUBDIRS ?= .

# Build the kernel module(s)
# Force PWD for those packages that want to use it to find their
# includes and other support files (Booo!)
define $(2)_KERNEL_MODULES_BUILD
	@$$(call MESSAGE,"Building kernel module(s)")
	$$(foreach d,$$($(2)_MODULE_SUBDIRS), \
		$$(LINUX_MAKE_ENV) $$($$(PKG)_MAKE) \
			-C $$(LINUX_DIR) \
			$$(LINUX_MAKE_FLAGS) \
			$$($(2)_MODULE_MAKE_OPTS) \
			PWD=$$(@D)/$$(d) \
			M=$$(@D)/$$(d) \
			modules$$(sep))
endef
$(2)_POST_BUILD_HOOKS += $(2)_KERNEL_MODULES_BUILD

# Install the kernel module(s)
# Force PWD for those packages that want to use it to find their
# includes and other support files (Booo!)
define $(2)_KERNEL_MODULES_INSTALL
	@$$(call MESSAGE,"Installing kernel module(s)")
	$$(foreach d,$$($(2)_MODULE_SUBDIRS), \
		$$(LINUX_MAKE_ENV) $$($$(PKG)_MAKE) \
			-C $$(LINUX_DIR) \
			$$(LINUX_MAKE_FLAGS) \
			$$($(2)_MODULE_MAKE_OPTS) \
			PWD=$$(@D)/$$(d) \
			M=$$(@D)/$$(d) \
			modules_install$$(sep))
endef
$(2)_POST_INSTALL_TARGET_HOOKS += $(2)_KERNEL_MODULES_INSTALL

endef

################################################################################
# kernel-module -- the target generator macro for kernel module packages
################################################################################

kernel-module = $(call inner-kernel-module,$(pkgname),$(call UPPERCASE,$(pkgname)))
