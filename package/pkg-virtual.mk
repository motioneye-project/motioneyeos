################################################################################
# Virtual package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for virtual packages. It should be used for all
# virtual packages.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this virtual infrastructure requires
# the .mk file to only call the 'virtual-package' macro.
#
################################################################################


################################################################################
# inner-virtual-package -- defines the dependency rules of the virtual
# package against its provider.
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

# Note: putting this comment here rather than in the define block, otherwise
# make would try to expand the $(error ...) in the comment, which is not
# really what we want.
# We need to use second-expansion for the $(error ...) call, below,
# so it is not evaluated now, but as part of the generated make code.

define inner-virtual-package

# Ensure the virtual package has an implementation defined.
ifeq ($$(BR2_PACKAGE_HAS_$(2)),y)
ifeq ($$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2))),)
$$(error No implementation selected for virtual package $(1). Configuration error)
endif
endif

# A virtual package does not have any source associated
$(2)_SOURCE =

# Fake a version string, so it looks nicer in the build log
$(2)_VERSION = virtual

# This must be repeated from inner-generic-package, otherwise we get an empty
# _DEPENDENCIES
ifeq ($(4),host)
$(2)_DEPENDENCIES ?= $$(filter-out host-skeleton host-toolchain $(1),\
	$$(patsubst host-host-%,host-%,$$(addprefix host-,$$($(3)_DEPENDENCIES))))
endif

# Add dependency against the provider
$(2)_DEPENDENCIES += $$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2)))

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# virtual-package -- the target generator macro for virtual packages
################################################################################

virtual-package = $(call inner-virtual-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-virtual-package = $(call inner-virtual-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
