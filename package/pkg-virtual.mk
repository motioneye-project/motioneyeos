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

# explicitly set these so we do not get confused by environment
# variables with the same names.
$(2)_VERSION =
$(2)_SOURCE =

$(2)_IS_VIRTUAL = YES

# Add dependency against the provider
# For a host package, there is no corresponding BR2_PACKAGE_PROVIDES_HOST_FOO,
# so we need to compute it from the target variant.
ifeq ($(4),target)
$(2)_DEPENDENCIES += $$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2)))
else
ifeq ($$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2))),)
# Inherit from target package BR2_PACKAGE_PROVIDES_FOO
$(2)_DEPENDENCIES += host-$$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(3)))
else
# BR2_PACKAGE_PROVIDES_HOST_<pkg> is explicitly defined
$(2)_DEPENDENCIES += $$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2)))
endif
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# virtual-package -- the target generator macro for virtual packages
################################################################################

virtual-package = $(call inner-virtual-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-virtual-package = $(call inner-virtual-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
