################################################################################
# Python package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files for Python packages. It should be used for all
# packages that use Python setup.py/setuptools as their build system.
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this Python infrastructure requires the
# .mk file to only specify metadata information about the package:
# name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default Python behaviour. The
# package can also define some post operation hooks.
#
################################################################################

# basename does not evaluate if a file exists, so we must check to ensure
# the _sysconfigdata__linux_*.py file exists. The "|| true" is added to return
# an empty string if the file does not exist.
PKG_PYTHON_SYSCONFIGDATA_PATH = $(PYTHON3_PATH)/_sysconfigdata__linux_*.py
PKG_PYTHON_SYSCONFIGDATA_NAME = `{ [ -e $(PKG_PYTHON_SYSCONFIGDATA_PATH) ] && basename $(PKG_PYTHON_SYSCONFIGDATA_PATH) .py; } || true`

# Target distutils-based packages
PKG_PYTHON_DISTUTILS_ENV = \
	PATH=$(BR_PATH) \
	$(TARGET_CONFIGURE_OPTS) \
	LDSHARED="$(TARGET_CROSS)gcc -shared" \
	PYTHONPATH="$(if $(BR2_PACKAGE_PYTHON3),$(PYTHON3_PATH),$(PYTHON_PATH))" \
	PYTHONNOUSERSITE=1 \
	_PYTHON_SYSCONFIGDATA_NAME="$(PKG_PYTHON_SYSCONFIGDATA_NAME)" \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

PKG_PYTHON_DISTUTILS_BUILD_OPTS = \
	--executable=/usr/bin/python

PKG_PYTHON_DISTUTILS_INSTALL_TARGET_OPTS = \
	--prefix=/usr \
	--root=$(TARGET_DIR)

PKG_PYTHON_DISTUTILS_INSTALL_STAGING_OPTS = \
	--prefix=/usr \
	--root=$(STAGING_DIR)

# Host distutils-based packages
HOST_PKG_PYTHON_DISTUTILS_ENV = \
	PATH=$(BR_PATH) \
	PYTHONNOUSERSITE=1 \
	$(HOST_CONFIGURE_OPTS)

HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPTS = \
	--prefix=$(HOST_DIR)

# Target setuptools-based packages
PKG_PYTHON_SETUPTOOLS_ENV = \
	_PYTHON_SYSCONFIGDATA_NAME="$(PKG_PYTHON_SYSCONFIGDATA_NAME)" \
	PATH=$(BR_PATH) \
	$(TARGET_CONFIGURE_OPTS) \
	PYTHONPATH="$(if $(BR2_PACKAGE_PYTHON3),$(PYTHON3_PATH),$(PYTHON_PATH))" \
	PYTHONNOUSERSITE=1 \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS = \
	--prefix=/usr \
	--executable=/usr/bin/python \
	--single-version-externally-managed \
	--root=$(TARGET_DIR)

PKG_PYTHON_SETUPTOOLS_INSTALL_STAGING_OPTS = \
	--prefix=/usr \
	--executable=/usr/bin/python \
	--single-version-externally-managed \
	--root=$(STAGING_DIR)

# Host setuptools-based packages
HOST_PKG_PYTHON_SETUPTOOLS_ENV = \
	PATH=$(BR_PATH) \
	PYTHONNOUSERSITE=1 \
	$(HOST_CONFIGURE_OPTS)

HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS = \
	--prefix=$(HOST_DIR) \
	--root=/ \
	--single-version-externally-managed

ifeq ($(BR2_PER_PACKAGE_DIRECTORIES),y)
define PKG_PYTHON_FIXUP_SYSCONFIGDATA
	find $(HOST_DIR)/lib/python* $(STAGING_DIR)/usr/lib/python* \
		-name "_sysconfigdata*.py" | xargs --no-run-if-empty \
		$(SED) "s:$(PER_PACKAGE_DIR)/[^/]\+/:$(PER_PACKAGE_DIR)/$($(PKG)_NAME)/:g"
endef
endif

################################################################################
# inner-python-package -- defines how the configuration, compilation
# and installation of a Python package should be done, implements a
# few hooks to tune the build process and calls the generic package
# infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-python-package

$(2)_ENV         ?=
$(2)_BUILD_OPTS   ?=
$(2)_INSTALL_OPTS ?=

ifndef $(2)_SETUP_TYPE
 ifdef $(3)_SETUP_TYPE
  $(2)_SETUP_TYPE = $$($(3)_SETUP_TYPE)
 else
  $$(error "$(2)_SETUP_TYPE must be set")
 endif
endif

# Distutils
ifeq ($$($(2)_SETUP_TYPE),distutils)
ifeq ($(4),target)
$(2)_BASE_ENV         = $$(PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPTS   = $$(PKG_PYTHON_DISTUTILS_BUILD_OPTS)
$(2)_BASE_INSTALL_TARGET_OPTS  = $$(PKG_PYTHON_DISTUTILS_INSTALL_TARGET_OPTS)
$(2)_BASE_INSTALL_STAGING_OPTS = $$(PKG_PYTHON_DISTUTILS_INSTALL_STAGING_OPTS)
else
$(2)_BASE_ENV         = $$(HOST_PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPTS   =
$(2)_BASE_INSTALL_OPTS = $$(HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPTS)
endif
# Setuptools
else ifeq ($$($(2)_SETUP_TYPE),setuptools)
ifeq ($(4),target)
$(2)_BASE_ENV         = $$(PKG_PYTHON_SETUPTOOLS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPTS   =
$(2)_BASE_INSTALL_TARGET_OPTS  = $$(PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS)
$(2)_BASE_INSTALL_STAGING_OPTS = $$(PKG_PYTHON_SETUPTOOLS_INSTALL_STAGING_OPTS)
else
$(2)_BASE_ENV         = $$(HOST_PKG_PYTHON_SETUPTOOLS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPTS   =
$(2)_BASE_INSTALL_OPTS = $$(HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPTS)
endif
else
$$(error "Invalid $(2)_SETUP_TYPE. Valid options are 'distutils' or 'setuptools'")
endif

# Target packages need both the python interpreter on the target (for
# runtime) and the python interpreter on the host (for
# compilation). However, host packages only need the python
# interpreter on the host, whose version may be enforced by setting
# the *_NEEDS_HOST_PYTHON variable.
#
# So:
# - for target packages, we always depend on the default python interpreter
#   (the one selected by the config);
# - for host packages:
#   - if *_NEEDS_HOST_PYTHON is not set, then we depend on use the default
#     interperter;
#   - otherwise, we depend on the one requested by *_NEEDS_HOST_PYTHON.
#
ifeq ($(4),target)
$(2)_DEPENDENCIES += $$(if $$(BR2_PACKAGE_PYTHON3),host-python3 python3,host-python python)
else
ifeq ($$($(2)_NEEDS_HOST_PYTHON),)
$(2)_DEPENDENCIES += $$(if $$(BR2_PACKAGE_PYTHON3),host-python3,host-python)
else
ifeq ($$($(2)_NEEDS_HOST_PYTHON),python2)
$(2)_DEPENDENCIES += host-python
else ifeq ($$($(2)_NEEDS_HOST_PYTHON),python3)
$(2)_DEPENDENCIES += host-python3
else
$$(error Incorrect value '$$($(2)_NEEDS_HOST_PYTHON)' for $(2)_NEEDS_HOST_PYTHON)
endif
endif # ($$($(2)_NEEDS_HOST_PYTHON),)
endif # ($(4),target)

# Setuptools based packages will need setuptools for the host Python
# interpreter (both host and target).
#
# If we have a host package that says "I need Python 3", we install
# setuptools for python3.
#
# If we have a host packge that says "I need Python 2", we install
# setuptools for python2.
#
# If we have a target package, or a host package that doesn't have any
# <pkg>_NEEDS_HOST_PYTHON, and BR2_PACKAGE_PYTHON3 is used, then
# Python 3.x is the default Python interpreter, so we install
# setuptools for python3.
#
# In all other cases, we install setuptools for python2. Those other
# cases are: a target package or host package with
# BR2_PACKAGE_PYTHON=y, or a host-package with neither
# BR2_PACKAGE_PYTHON3=y or BR2_PACKAGE_PYTHON=y.
ifeq ($$($(2)_SETUP_TYPE),setuptools)
ifeq ($(4):$$($(2)_NEEDS_HOST_PYTHON),host:python3)
$(2)_DEPENDENCIES += $$(if $$(filter host-python3-setuptools,$(1)),,host-python3-setuptools)
else ifeq ($(4):$$($(2)_NEEDS_HOST_PYTHON),host:python2)
$(2)_DEPENDENCIES += $$(if $$(filter host-python-setuptools,$(1)),,host-python-setuptools)
else ifeq ($$(BR2_PACKAGE_PYTHON3),y)
$(2)_DEPENDENCIES += $$(if $$(filter host-python3-setuptools,$(1)),,host-python3-setuptools)
else
$(2)_DEPENDENCIES += $$(if $$(filter host-python-setuptools,$(1)),,host-python-setuptools)
endif
endif # SETUP_TYPE

# Python interpreter to use for building the package.
#
# We may want to specify the python interpreter to be used for building a
# package, especially for host-packages (target packages must be built using
# the same version of the interpreter as the one installed on the target).
#
# So:
# - for target packages, we always use the default python interpreter (which
#   is the same version as the one built and installed on the target);
# - for host packages:
#   - if *_NEEDS_HOST_PYTHON is not set, then we use use the default
#     interperter;
#   - otherwise, we use the one requested by *_NEEDS_HOST_PYTHON.
#
ifeq ($(4),target)
$(2)_PYTHON_INTERPRETER = $$(HOST_DIR)/bin/python
else
ifeq ($$($(2)_NEEDS_HOST_PYTHON),)
$(2)_PYTHON_INTERPRETER = $$(HOST_DIR)/bin/python
else
$(2)_PYTHON_INTERPRETER = $$(HOST_DIR)/bin/$$($(2)_NEEDS_HOST_PYTHON)
endif
endif

$(2)_PRE_CONFIGURE_HOOKS += PKG_PYTHON_FIXUP_SYSCONFIGDATA

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$($(2)_PYTHON_INTERPRETER) setup.py \
		$$($$(PKG)_BASE_BUILD_TGT) \
		$$($$(PKG)_BASE_BUILD_OPTS) $$($$(PKG)_BUILD_OPTS))
endef
endif

#
# Host installation step. Only define it if not already defined by the
# package .mk file.
#
ifndef $(2)_INSTALL_CMDS
define $(2)_INSTALL_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$($(2)_PYTHON_INTERPRETER) setup.py install \
		$$($$(PKG)_BASE_INSTALL_OPTS) $$($$(PKG)_INSTALL_OPTS))
endef
endif

#
# Target installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_TARGET_CMDS
define $(2)_INSTALL_TARGET_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$($(2)_PYTHON_INTERPRETER) setup.py install --no-compile \
		$$($$(PKG)_BASE_INSTALL_TARGET_OPTS) \
		$$($$(PKG)_INSTALL_TARGET_OPTS))
endef
endif

#
# Staging installation step. Only define it if not already defined by
# the package .mk file.
#
ifndef $(2)_INSTALL_STAGING_CMDS
define $(2)_INSTALL_STAGING_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$$($(2)_PYTHON_INTERPRETER) setup.py install \
		$$($$(PKG)_BASE_INSTALL_STAGING_OPTS) \
		$$($$(PKG)_INSTALL_STAGING_OPTS))
endef
endif

# Call the generic package infrastructure to generate the necessary
# make targets
$(call inner-generic-package,$(1),$(2),$(3),$(4))

endef

################################################################################
# python-package -- the target generator macro for Python packages
################################################################################

python-package = $(call inner-python-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
host-python-package = $(call inner-python-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)
