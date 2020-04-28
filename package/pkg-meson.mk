################################################################################
# Meson package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for Meson packages. It should be used for all
# packages that use Meson as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this Meson infrastructure requires
# the .mk file to only specify metadata information about the
# package: name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default Meson behaviour. The
# package can also define some post operation hooks.
#
################################################################################

#
# Pass PYTHONNOUSERSITE environment variable when invoking Meson or Ninja, so
# $(HOST_DIR)/bin/python3 will not look for Meson modules in
# $HOME/.local/lib/python3.x/site-packages
#
MESON		= PYTHONNOUSERSITE=y $(HOST_DIR)/bin/meson
NINJA		= PYTHONNOUSERSITE=y $(HOST_DIR)/bin/ninja
NINJA_OPTS	= $(if $(VERBOSE),-v) -j$(PARALLEL_JOBS)

################################################################################
# inner-meson-package -- defines how the configuration, compilation and
# installation of a Meson package should be done, implements a few hooks to
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

define inner-meson-package

$(2)_CONF_ENV		?=
$(2)_CONF_OPTS		?=
$(2)_NINJA_ENV		?=

#
# Configure step. Only define it if not already defined by the package
# .mk file. And take care of the differences between host and target
# packages.
#
ifndef $(2)_CONFIGURE_CMDS
ifeq ($(4),target)

$(2)_CFLAGS ?= $$(TARGET_CFLAGS)
$(2)_LDFLAGS ?= $$(TARGET_LDFLAGS)
$(2)_CXXFLAGS ?= $$(TARGET_CXXFLAGS)

# Configure package for target
#
#
define $(2)_CONFIGURE_CMDS
	rm -rf $$($$(PKG)_SRCDIR)/build
	mkdir -p $$($$(PKG)_SRCDIR)/build
	sed -e 's%@TARGET_CROSS@%$$(TARGET_CROSS)%g' \
	    -e 's%@TARGET_ARCH@%$$(HOST_MESON_TARGET_CPU_FAMILY)%g' \
	    -e 's%@TARGET_CPU@%$$(HOST_MESON_TARGET_CPU)%g' \
	    -e 's%@TARGET_ENDIAN@%$$(HOST_MESON_TARGET_ENDIAN)%g' \
	    -e 's%@TARGET_CFLAGS@%$$(call make-comma-list,$$($(2)_CFLAGS))%g' \
	    -e 's%@TARGET_LDFLAGS@%$$(call make-comma-list,$$($(2)_LDFLAGS))%g' \
	    -e 's%@TARGET_CXXFLAGS@%$$(call make-comma-list,$$($(2)_CXXFLAGS))%g' \
	    -e 's%@HOST_DIR@%$$(HOST_DIR)%g' \
	    -e 's%@STAGING_DIR@%$$(STAGING_DIR)%g' \
	    -e 's%@STATIC@%$$(if $$(BR2_STATIC_LIBS),true,false)%g' \
	    -e "/^\[binaries\]$$$$/s:$$$$:$$(foreach x,$$($(2)_MESON_EXTRA_BINARIES),\n$$(x)):" \
	    -e "/^\[properties\]$$$$/s:$$$$:$$(foreach x,$$($(2)_MESON_EXTRA_PROPERTIES),\n$$(x)):" \
	    package/meson/cross-compilation.conf.in \
	    > $$($$(PKG)_SRCDIR)/build/cross-compilation.conf
	PATH=$$(BR_PATH) $$($$(PKG)_CONF_ENV) $$(MESON) \
		--prefix=/usr \
		--libdir=lib \
		--default-library=$(if $(BR2_STATIC_LIBS),static,shared) \
		--buildtype=$(if $(BR2_ENABLE_DEBUG),debug,release) \
		--cross-file=$$($$(PKG)_SRCDIR)/build/cross-compilation.conf \
		-Dbuild.pkg_config_path=$$(HOST_DIR)/lib/pkgconfig \
		$$($$(PKG)_CONF_OPTS) \
		$$($$(PKG)_SRCDIR) $$($$(PKG)_SRCDIR)/build
endef
else

# Configure package for host
define $(2)_CONFIGURE_CMDS
	rm -rf $$($$(PKG)_SRCDIR)/build
	mkdir -p $$($$(PKG)_SRCDIR)/build
	$$(HOST_CONFIGURE_OPTS) \
	$$($$(PKG)_CONF_ENV) $$(MESON) \
		--prefix=$$(HOST_DIR) \
		--libdir=lib \
		--sysconfdir=$$(HOST_DIR)/etc \
		--localstatedir=$$(HOST_DIR)/var \
		--default-library=shared \
		--buildtype=release \
		$$($$(PKG)_CONF_OPTS) \
		$$($$(PKG)_SRCDIR) $$($$(PKG)_SRCDIR)/build
endef
endif
endif

$(2)_DEPENDENCIES += host-meson

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
ifeq ($(4),target)
define $(2)_BUILD_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_NINJA_ENV) \
		$$(NINJA) $$(NINJA_OPTS) $$($$(PKG)_NINJA_OPTS) -C $$($$(PKG)_SRCDIR)/build
endef
else
define $(2)_BUILD_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_NINJA_ENV) \
		$$(NINJA) $$(NINJA_OPTS) $$($$(PKG)_NINJA_OPTS) -C $$($$(PKG)_SRCDIR)/build
endef
endif
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	$$(HOST_MAKE_ENV) $$($$(PKG)_NINJA_ENV) \
		$$(NINJA) $$(NINJA_OPTS) -C $$($$(PKG)_SRCDIR)/build install
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_NINJA_ENV) DESTDIR=$$(STAGING_DIR) \
		$$(NINJA) $$(NINJA_OPTS) -C $$($$(PKG)_SRCDIR)/build install
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	$$(TARGET_MAKE_ENV) $$($$(PKG)_NINJA_ENV) DESTDIR=$$(TARGET_DIR) \
		$$(NINJA) $$(NINJA_OPTS) -C $$($$(PKG)_SRCDIR)/build install
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# meson-package -- the target generator macro for Meson packages
################################################################################

meson-package = $(call inner-meson-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-meson-package = $(call inner-meson-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)

################################################################################
# Generation of the Meson cross-compilation.conf file
################################################################################

# Generate a Meson cross-compilation.conf suitable for use with the
# SDK; also install the file as a template for users to add their
# own flags if they need to.
define PKG_MESON_INSTALL_CROSS_CONF
	mkdir -p $(HOST_DIR)/etc/meson
	sed -e 's%@TARGET_CROSS@%$(TARGET_CROSS)%g' \
	    -e 's%@TARGET_ARCH@%$(HOST_MESON_TARGET_CPU_FAMILY)%g' \
	    -e 's%@TARGET_CPU@%$(HOST_MESON_TARGET_CPU)%g' \
	    -e 's%@TARGET_ENDIAN@%$(HOST_MESON_TARGET_ENDIAN)%g' \
	    -e 's%@TARGET_CFLAGS@%$(call make-comma-list,$(TARGET_CFLAGS))@PKG_TARGET_CFLAGS@%g' \
	    -e 's%@TARGET_LDFLAGS@%$(call make-comma-list,$(TARGET_LDFLAGS))@PKG_TARGET_CFLAGS@%g' \
	    -e 's%@TARGET_CXXFLAGS@%$(call make-comma-list,$(TARGET_CXXFLAGS))@PKG_TARGET_CFLAGS@%g' \
	    -e 's%@HOST_DIR@%$(HOST_DIR)%g' \
	    -e 's%@STAGING_DIR@%$(STAGING_DIR)%g' \
	    -e 's%@STATIC@%$$(if $$(BR2_STATIC_LIBS),true,false)%g' \
	    $(HOST_MESON_PKGDIR)/cross-compilation.conf.in \
	    > $(HOST_DIR)/etc/meson/cross-compilation.conf.in
	sed -e 's%@PKG_TARGET_CFLAGS@%%g' \
	    -e 's%@PKG_TARGET_LDFLAGS@%%g' \
	    -e 's%@PKG_TARGET_CXXFLAGS@%%g' \
	    $(HOST_DIR)/etc/meson/cross-compilation.conf.in \
	    > $(HOST_DIR)/etc/meson/cross-compilation.conf
endef

TOOLCHAIN_POST_INSTALL_STAGING_HOOKS += PKG_MESON_INSTALL_CROSS_CONF
