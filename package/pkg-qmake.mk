################################################################################
# QMake package infrastructure
#
# This file implements an infrastructure that eases development of package
# .mk files for QMake packages. It should be used for all packages that use
# Qmake as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this QMake infrastructure requires the .mk file
# to only specify metadata information about the package: name, version,
# download URL, etc.
#
# We still allow the package .mk file to override what the different steps
# are doing, if needed. For example, if <PKG>_BUILD_CMDS is already defined,
# it is used as the list of commands to perform to build the package,
# instead of the default QMake behaviour. The package can also define some
# post operation hooks.
#
################################################################################

################################################################################
# inner-qmake-package -- defines how the configuration, compilation and
# installation of a qmake package should be done, implements a few hooks
# to tune the build process for qmake specifities and calls the generic
# package infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
################################################################################

define inner-qmake-package

$(2)_CONF_ENV			?=
$(2)_CONF_OPTS			?=
$(2)_MAKE_ENV			?=
$(2)_MAKE_OPTS			?=
$(2)_INSTALL_STAGING_OPTS	?= install
$(2)_INSTALL_TARGET_OPTS	?= $$($(2)_INSTALL_STAGING_OPTS)

ifneq ($(1),qt5base)
$(2)_DEPENDENCIES 		+= qt5base
endif

#
# Configure step. Only define it if not already defined by the package
# .mk file.
#
ifndef $(2)_CONFIGURE_CMDS
define $(2)_CONFIGURE_CMDS
	$$(QT5_QT_CONF_FIXUP)
	cd $$($(2)_BUILDDIR) && \
	$$(TARGET_MAKE_ENV) $$($(2)_CONF_ENV) $$(QT5_QMAKE) $$($(2)_CONF_OPTS)
endef
endif

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	$$(TARGET_MAKE_ENV) $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_BUILDDIR) $$($(2)_MAKE_OPTS)
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$$(TARGET_MAKE_ENV) $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_BUILDDIR) $$($(2)_INSTALL_STAGING_OPTS)
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
# Unfortunately we can't use INSTALL_ROOT to directly install to TARGET_DIR
# because in a crosscompile setup, the qmake generated install destinations
# are prefixed with the hardcoded sysroot (=STAGING_DIR) and hostprefix
# (=HOST_DIR).
# Instead we set INSTALL_ROOT, which comes before the install path, to a
# temporary folder inside the build directory and effectively install to
# $(@D)/tmp-target-install/$(STAGING_DIR) and $(@D)/tmp-target-install/$(HOST_DIR).
# We subsequently rsync only the files from the temporary staging dir and that
# way exclude files for the build host from target.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$$(TARGET_MAKE_ENV) $$($(2)_MAKE_ENV) $$(MAKE) -C $$($(2)_BUILDDIR) INSTALL_ROOT=$$($(2)_BUILDDIR)tmp-target-install $$($(2)_INSTALL_TARGET_OPTS)
	rsync -arv $$($(2)_BUILDDIR)tmp-target-install$$(STAGING_DIR)/ $$(TARGET_DIR)/
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# qmake-package -- the target generator macro for QMake packages
################################################################################

qmake-package = $(call inner-qmake-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
