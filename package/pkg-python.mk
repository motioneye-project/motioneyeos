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
# .mk file to only specify metadata informations about the package:
# name, version, download URL, etc.
#
# We still allow the package .mk file to override what the different
# steps are doing, if needed. For example, if <PKG>_BUILD_CMDS is
# already defined, it is used as the list of commands to perform to
# build the package, instead of the default Python behaviour. The
# package can also define some post operation hooks.
#
################################################################################

# Target distutils-based packages
PKG_PYTHON_DISTUTILS_ENV = \
	PATH="$(TARGET_PATH)" \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CROSS)gcc -shared" \
	CROSS_COMPILING=yes \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

PKG_PYTHON_DISTUTILS_BUILD_OPT = \
	--executable=/usr/bin/python

PKG_PYTHON_DISTUTILS_INSTALL_OPT = \
	--prefix=$(TARGET_DIR)/usr

# Host distutils-based packages
HOST_PKG_PYTHON_DISTUTILS_ENV = \
	PATH="$(HOST_PATH)"

HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPT = \
	--prefix=$(HOST_DIR)/usr

# Target setuptools-based packages
PKG_PYTHON_SETUPTOOLS_ENV = \
	PATH="$(TARGET_PATH)" \
	PYTHONPATH="$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
	CROSS_COMPILING=yes \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr

PKG_PYTHON_SETUPTOOLS_INSTALL_OPT = \
	--prefix=$(TARGET_DIR)/usr \
	--executable=/usr/bin/python \
	--single-version-externally-managed \
	--root=/

# Host setuptools-based packages
HOST_PKG_PYTHON_SETUPTOOLS_ENV = \
	PATH="$(HOST_PATH)" \
	PYTHONXCPREFIX="$(HOST_DIR)/usr/"

HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPT = \
	--prefix=$(HOST_DIR)/usr

################################################################################
# inner-python-package -- defines how the configuration, compilation
# and installation of a Python package should be done, implements a
# few hooks to tune the build process and calls the generic package
# infrastructure to generate the necessary make targets
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including an HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-python-package

$(2)_SRCDIR	= $$($(2)_DIR)/$($(2)_SUBDIR)
$(2)_BUILDDIR	= $$($(2)_SRCDIR)

$(2)_ENV         ?=
$(2)_BUILD_OPT   ?=
$(2)_INSTALL_OPT ?=

ifndef $(2)_SETUP_TYPE
 ifdef $(3)_SETUP_TYPE
  $(2)_SETUP_TYPE = $($(3)_SETUP_TYPE)
 else
  $$(error "$(2)_SETUP_TYPE must be set")
 endif
endif

# Distutils
ifeq ($$($(2)_SETUP_TYPE),distutils)
ifeq ($(4),target)
$(2)_BASE_ENV         = $$(PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPT   = $$(PKG_PYTHON_DISTUTILS_BUILD_OPT)
$(2)_BASE_INSTALL_OPT = $$(PKG_PYTHON_DISTUTILS_INSTALL_OPT)
else
$(2)_BASE_ENV         = $$(HOST_PKG_PYTHON_DISTUTILS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPT   =
$(2)_BASE_INSTALL_OPT = $$(HOST_PKG_PYTHON_DISTUTILS_INSTALL_OPT)
endif
# Setuptools
else ifeq ($$($(2)_SETUP_TYPE),setuptools)
ifeq ($(4),target)
$(2)_BASE_ENV         = $$(PKG_PYTHON_SETUPTOOLS_ENV)
$(2)_BASE_BUILD_TGT   = build -x
$(2)_BASE_BUILD_OPT   =
$(2)_BASE_INSTALL_OPT = $$(PKG_PYTHON_SETUPTOOLS_INSTALL_OPT)
else
$(2)_BASE_ENV         = $$(HOST_PKG_PYTHON_SETUPTOOLS_ENV)
$(2)_BASE_BUILD_TGT   = build
$(2)_BASE_BUILD_OPT   =
$(2)_BASE_INSTALL_OPT = $$(HOST_PKG_PYTHON_SETUPTOOLS_INSTALL_OPT)
endif
else
$$(error "Invalid $(2)_SETUP_TYPE. Valid options are 'distutils' or 'setuptools'")
endif

# The below statement intends to calculate the dependencies of host
# packages by derivating them from the dependencies of the
# corresponding target package, after adding the 'host-' prefix in
# front of the dependencies.
#
# However it must be repeated from inner-generic-package, as we need
# to exclude the python, host-python, host-python-setuptools and
# host-distutilscross packages, which are added below in the list of
# dependencies depending on the package characteristics, and shouldn't
# be derived automatically from the dependencies of the corresponding
# target package. For example, target packages need
# host-python-distutilscross, but not host packages.
$(2)_DEPENDENCIES ?= $(filter-out host-python host-python-setuptools host-python-distutilscross $(1),$(patsubst host-host-%,host-%,$(addprefix host-,$($(3)_DEPENDENCIES))))

# Target packages need both the python interpreter on the target (for
# runtime) and the python interpreter on the host (for
# compilation). However, host packages only need the python
# interpreter on the host.
ifeq ($(4),target)
$(2)_DEPENDENCIES += host-python python
else
$(2)_DEPENDENCIES += host-python
endif

# Setuptools based packages will need host-python-setuptools (both
# host and target) and host-python-distutilscross (only target
# packages). We need to have a special exclusion for the
# host-setuptools package itself: it is setuptools-based, but
# shouldn't depend on host-setuptools (because it would otherwise
# depend on itself!).
ifeq ($$($(2)_SETUP_TYPE),setuptools)
ifneq ($(2),HOST_PYTHON_SETUPTOOLS)
$(2)_DEPENDENCIES += host-python-setuptools
ifeq ($(4),target)
$(2)_DEPENDENCIES += host-python-distutilscross
endif
endif
endif

#
# Build step. Only define it if not already defined by the package .mk
# file.
#
ifndef $(2)_BUILD_CMDS
define $(2)_BUILD_CMDS
	(cd $$($$(PKG)_BUILDDIR)/; \
		$$($$(PKG)_BASE_ENV) $$($$(PKG)_ENV) \
		$(HOST_DIR)/usr/bin/python setup.py \
		$$($$(PKG)_BASE_BUILD_TGT) \
		$$($$(PKG)_BASE_BUILD_OPT) $$($$(PKG)_BUILD_OPT))
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
		$(HOST_DIR)/usr/bin/python setup.py install \
		$$($$(PKG)_BASE_INSTALL_OPT) $$($$(PKG)_INSTALL_OPT))
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
		$(HOST_DIR)/usr/bin/python setup.py install \
		$$($$(PKG)_BASE_INSTALL_OPT) $$($$(PKG)_INSTALL_OPT))
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
