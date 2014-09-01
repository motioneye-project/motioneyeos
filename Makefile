# Makefile for buildroot
#
# Copyright (C) 1999-2005 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2006-2014 by the Buildroot developers <buildroot@uclibc.org>
# Copyright (C) 2014 by the Buildroot developers <buildroot@buildroot.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

#--------------------------------------------------------------
# Just run 'make menuconfig', configure stuff, then run 'make'.
# You shouldn't need to mess with anything beyond this point...
#--------------------------------------------------------------

# Set and export the version string
export BR2_VERSION := 2014.08

# Check for minimal make version (note: this check will break at make 10.x)
MIN_MAKE_VERSION = 3.81
ifneq ($(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))),$(MIN_MAKE_VERSION))
$(error You have make '$(MAKE_VERSION)' installed. GNU make >= $(MIN_MAKE_VERSION) is required)
endif

export HOSTARCH := $(shell uname -m | \
	sed -e s/i.86/x86/ \
	    -e s/sun4u/sparc64/ \
	    -e s/arm.*/arm/ \
	    -e s/sa110/arm/ \
	    -e s/ppc64/powerpc64/ \
	    -e s/ppc/powerpc/ \
	    -e s/macppc/powerpc/\
	    -e s/sh.*/sh/)

# Parallel execution of this Makefile is disabled because it changes
# the packages building order, that can be a problem for two reasons:
# - If a package has an unspecified optional dependency and that
#   dependency is present when the package is built, it is used,
#   otherwise it isn't (but compilation happily proceeds) so the end
#   result will differ if the order is swapped due to parallel
#   building.
# - Also changing the building order can be a problem if two packages
#   manipulate the same file in the target directory.
#
# Taking into account the above considerations, if you still want to execute
# this top-level Makefile in parallel comment the ".NOTPARALLEL" line and
# build using the following command:
#	make BR2_JLEVEL= -j$((`getconf _NPROCESSORS_ONLN`+1))
.NOTPARALLEL:

# absolute path
TOPDIR := $(shell pwd)
CONFIG_CONFIG_IN = Config.in
CONFIG = support/kconfig
DATE := $(shell date +%Y%m%d)

# Compute the full local version string so packages can use it as-is
# Need to export it, so it can be got from environment in children (eg. mconf)
export BR2_VERSION_FULL := $(BR2_VERSION)$(shell $(TOPDIR)/support/scripts/setlocalversion)

noconfig_targets := menuconfig nconfig gconfig xconfig config oldconfig randconfig \
	defconfig %_defconfig allyesconfig allnoconfig silentoldconfig release \
	randpackageconfig allyespackageconfig allnopackageconfig \
	source-check print-version olddefconfig

# Strip quotes and then whitespaces
qstrip = $(strip $(subst ",,$(1)))
#"))

# Variables for use in Make constructs
comma := ,
empty :=
space := $(empty) $(empty)

ifneq ("$(origin O)", "command line")
O := output
CONFIG_DIR := $(TOPDIR)
NEED_WRAPPER =
else
# other packages might also support Linux-style out of tree builds
# with the O=<dir> syntax (E.G. BusyBox does). As make automatically
# forwards command line variable definitions those packages get very
# confused. Fix this by telling make to not do so
MAKEOVERRIDES =
# strangely enough O is still passed to submakes with MAKEOVERRIDES
# (with make 3.81 atleast), the only thing that changes is the output
# of the origin function (command line -> environment).
# Unfortunately some packages don't look at origin (E.G. uClibc 0.9.31+)
# To really make O go away, we have to override it.
override O := $(O)
CONFIG_DIR := $(O)
# we need to pass O= everywhere we call back into the toplevel makefile
EXTRAMAKEARGS = O=$(O)
NEED_WRAPPER = y
endif

# bash prints the name of the directory on 'cd <dir>' if CDPATH is
# set, so unset it here to not cause problems. Notice that the export
# line doesn't affect the environment of $(shell ..) calls, so
# explictly throw away any output from 'cd' here.
export CDPATH :=
BASE_DIR := $(shell mkdir -p $(O) && cd $(O) >/dev/null && pwd)
$(if $(BASE_DIR),, $(error output directory "$(O)" does not exist))


# Handling of BR2_EXTERNAL.
#
# The value of BR2_EXTERNAL is stored in .br-external in the output directory.
# On subsequent invocations of make, it is read in. It can still be overridden
# on the command line, therefore the file is re-created every time make is run.
#
# When BR2_EXTERNAL is not set, the .br-external file is removed and we point
# to support/dummy-external. This makes sure we can unconditionally include the
# Config.in and external.mk from the BR2_EXTERNAL directory. In this case,
# override is necessary so the user can clear BR2_EXTERNAL from the command
# line, but the dummy path is still used internally.

BR2_EXTERNAL_FILE = $(BASE_DIR)/.br-external
-include $(BR2_EXTERNAL_FILE)
ifeq ($(BR2_EXTERNAL),)
  override BR2_EXTERNAL = support/dummy-external
  $(shell rm -f $(BR2_EXTERNAL_FILE))
else
  _BR2_EXTERNAL = $(shell cd $(BR2_EXTERNAL) >/dev/null 2>&1 && pwd)
  ifeq ($(_BR2_EXTERNAL),)
    $(error BR2_EXTERNAL='$(BR2_EXTERNAL)' does not exist, relative to $(TOPDIR))
  endif
  override BR2_EXTERNAL := $(_BR2_EXTERNAL)
  $(shell echo BR2_EXTERNAL ?= $(BR2_EXTERNAL) > $(BR2_EXTERNAL_FILE))
endif

# To make sure the the environment variable overrides the .config option,
# set this before including .config.
ifneq ($(BR2_DL_DIR),)
DL_DIR := $(BR2_DL_DIR)
endif


# Need that early, before we scan packages
# Avoids doing the $(or...) everytime
BR_GRAPH_OUT := $(or $(BR2_GRAPH_OUT),pdf)

BUILD_DIR := $(BASE_DIR)/build
BINARIES_DIR := $(BASE_DIR)/images
TARGET_DIR := $(BASE_DIR)/target
# initial definition so that 'make clean' works for most users, even without
# .config. HOST_DIR will be overwritten later when .config is included.
HOST_DIR := $(BASE_DIR)/host

LEGAL_INFO_DIR = $(BASE_DIR)/legal-info
REDIST_SOURCES_DIR_TARGET = $(LEGAL_INFO_DIR)/sources
REDIST_SOURCES_DIR_HOST = $(LEGAL_INFO_DIR)/host-sources
LICENSE_FILES_DIR_TARGET = $(LEGAL_INFO_DIR)/licenses
LICENSE_FILES_DIR_HOST = $(LEGAL_INFO_DIR)/host-licenses
LEGAL_MANIFEST_CSV_TARGET = $(LEGAL_INFO_DIR)/manifest.csv
LEGAL_MANIFEST_CSV_HOST = $(LEGAL_INFO_DIR)/host-manifest.csv
LEGAL_LICENSES_TXT_TARGET = $(LEGAL_INFO_DIR)/licenses.txt
LEGAL_LICENSES_TXT_HOST = $(LEGAL_INFO_DIR)/host-licenses.txt
LEGAL_WARNINGS = $(LEGAL_INFO_DIR)/.warnings
LEGAL_REPORT = $(LEGAL_INFO_DIR)/README

BR2_CONFIG = $(CONFIG_DIR)/.config

# Pull in the user's configuration file
ifeq ($(filter $(noconfig_targets),$(MAKECMDGOALS)),)
-include $(BR2_CONFIG)
endif

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
ifdef V
  ifeq ("$(origin V)", "command line")
    KBUILD_VERBOSE = $(V)
  endif
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet =
  Q =
ifndef VERBOSE
  VERBOSE = 1
endif
else
  quiet = quiet_
  Q = @
endif

# we want bash as shell
SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	 else if [ -x /bin/bash ]; then echo /bin/bash; \
	 else echo sh; fi; fi)

# kconfig uses CONFIG_SHELL
CONFIG_SHELL := $(SHELL)

export SHELL CONFIG_SHELL quiet Q KBUILD_VERBOSE VERBOSE

ifndef HOSTAR
HOSTAR := ar
endif
ifndef HOSTAS
HOSTAS := as
endif
ifndef HOSTCC
HOSTCC := gcc
HOSTCC := $(shell which $(HOSTCC) || type -p $(HOSTCC) || echo gcc)
endif
HOSTCC_NOCCACHE := $(HOSTCC)
ifndef HOSTCXX
HOSTCXX := g++
HOSTCXX := $(shell which $(HOSTCXX) || type -p $(HOSTCXX) || echo g++)
endif
HOSTCXX_NOCCACHE := $(HOSTCXX)
ifndef HOSTFC
HOSTFC := gfortran
endif
ifndef HOSTCPP
HOSTCPP := cpp
endif
ifndef HOSTLD
HOSTLD := ld
endif
ifndef HOSTLN
HOSTLN := ln
endif
ifndef HOSTNM
HOSTNM := nm
endif
ifndef HOSTOBJCOPY
HOSTOBJCOPY := objcopy
endif
ifndef HOSTRANLIB
HOSTRANLIB := ranlib
endif
HOSTAR := $(shell which $(HOSTAR) || type -p $(HOSTAR) || echo ar)
HOSTAS := $(shell which $(HOSTAS) || type -p $(HOSTAS) || echo as)
HOSTFC := $(shell which $(HOSTLD) || type -p $(HOSTLD) || echo || which g77 || type -p g77 || echo gfortran)
HOSTCPP := $(shell which $(HOSTCPP) || type -p $(HOSTCPP) || echo cpp)
HOSTLD := $(shell which $(HOSTLD) || type -p $(HOSTLD) || echo ld)
HOSTLN := $(shell which $(HOSTLN) || type -p $(HOSTLN) || echo ln)
HOSTNM := $(shell which $(HOSTNM) || type -p $(HOSTNM) || echo nm)
HOSTOBJCOPY := $(shell which $(HOSTOBJCOPY) || type -p $(HOSTOBJCOPY) || echo objcopy)
HOSTRANLIB := $(shell which $(HOSTRANLIB) || type -p $(HOSTRANLIB) || echo ranlib)

export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTFC HOSTLD
export HOSTCC_NOCCACHE HOSTCXX_NOCCACHE

# Make sure pkg-config doesn't look outside the buildroot tree
unexport PKG_CONFIG_PATH
unexport PKG_CONFIG_SYSROOT_DIR
unexport PKG_CONFIG_LIBDIR

# Having DESTDIR set in the environment confuses the installation
# steps of some packages.
unexport DESTDIR

# Causes breakage with packages that needs host-ruby
unexport RUBYOPT

include package/pkg-utils.mk

ifeq ($(BR2_HAVE_DOT_CONFIG),y)

################################################################################
#
# Hide troublesome environment variables from sub processes
#
################################################################################
unexport CROSS_COMPILE
unexport ARCH
unexport CC
unexport CXX
unexport CPP
unexport CFLAGS
unexport CXXFLAGS
unexport GREP_OPTIONS
unexport TAR_OPTIONS
unexport CONFIG_SITE
unexport QMAKESPEC
unexport TERMINFO

GNU_HOST_NAME := $(shell support/gnuconfig/config.guess)

TARGETS :=

# silent mode requested?
QUIET := $(if $(findstring s,$(MAKEFLAGS)),-q)

# Strip off the annoying quoting
ARCH := $(call qstrip,$(BR2_ARCH))

KERNEL_ARCH := $(shell echo "$(ARCH)" | sed -e "s/-.*//" \
	-e s/i.86/i386/ -e s/sun4u/sparc64/ \
	-e s/arcle/arc/ \
	-e s/arceb/arc/ \
	-e s/arm.*/arm/ -e s/sa110/arm/ \
	-e s/aarch64/arm64/ \
	-e s/bfin/blackfin/ \
	-e s/parisc64/parisc/ \
	-e s/powerpc64.*/powerpc/ \
	-e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
	-e s/sh.*/sh/ \
	-e s/microblazeel/microblaze/)

ZCAT := $(call qstrip,$(BR2_ZCAT))
BZCAT := $(call qstrip,$(BR2_BZCAT))
XZCAT := $(call qstrip,$(BR2_XZCAT))
TAR_OPTIONS = $(call qstrip,$(BR2_TAR_OPTIONS)) -xf

# packages compiled for the host go here
HOST_DIR := $(call qstrip,$(BR2_HOST_DIR))

# Quotes are needed for spaces and all in the original PATH content.
BR_PATH = "$(HOST_DIR)/bin:$(HOST_DIR)/sbin:$(HOST_DIR)/usr/bin:$(HOST_DIR)/usr/sbin:$(PATH)"

TARGET_SKELETON = $(TOPDIR)/system/skeleton

# Location of a file giving a big fat warning that output/target
# should not be used as the root filesystem.
TARGET_DIR_WARNING_FILE = $(TARGET_DIR)/THIS_IS_NOT_YOUR_ROOT_FILESYSTEM

ifeq ($(BR2_CCACHE),y)
CCACHE := $(HOST_DIR)/usr/bin/ccache
BR_CACHE_DIR = $(call qstrip,$(BR2_CCACHE_DIR))
export BR_CACHE_DIR
HOSTCC := $(CCACHE) $(HOSTCC)
HOSTCXX := $(CCACHE) $(HOSTCXX)
endif

# Scripts in support/ or post-build scripts may need to reference
# these locations, so export them so it is easier to use
export BR2_CONFIG
export TARGET_DIR
export STAGING_DIR
export HOST_DIR
export BINARIES_DIR
export BASE_DIR

################################################################################
#
# You should probably leave this stuff alone unless you know
# what you are doing.
#
################################################################################

all: world

# Include legacy before the other things, because package .mk files
# may rely on it.
ifneq ($(BR2_DEPRECATED),y)
include Makefile.legacy
endif

include package/Makefile.in
include support/dependencies/dependencies.mk

# We also need the various per-package makefiles, which also add
# each selected package to TARGETS if that package was selected
# in the .config file.
include toolchain/*.mk
include toolchain/*/*.mk

# Include the package override file if one has been provided in the
# configuration.
PACKAGE_OVERRIDE_FILE = $(call qstrip,$(BR2_PACKAGE_OVERRIDE_FILE))
ifneq ($(PACKAGE_OVERRIDE_FILE),)
-include $(PACKAGE_OVERRIDE_FILE)
endif

include $(sort $(wildcard package/*/*.mk))

include boot/common.mk
include linux/linux.mk
include system/system.mk
include fs/common.mk

include $(BR2_EXTERNAL)/external.mk

TARGETS_SOURCE := $(patsubst %,%-source,$(TARGETS))
TARGETS_DIRCLEAN := $(patsubst %,%-dirclean,$(TARGETS))

# host-* dependencies have to be handled specially, as those aren't
# visible in Kconfig and hence not added to a variable like TARGETS.
# instead, find all the host-* targets listed in each <PKG>_DEPENDENCIES
# variable for each enabled target.
# Notice: this only works for newstyle gentargets/autotargets packages
TARGETS_HOST_DEPS = $(sort $(filter host-%,$(foreach dep,\
		$(addsuffix _DEPENDENCIES,\
			$(call UPPERCASE,$(TARGETS) $(TARGETS_ROOTFS))),\
		$($(dep)))))
# Host packages can in turn have their own dependencies. Likewise find
# all the package names listed in the HOST_<PKG>_DEPENDENCIES for each
# host package found above. Ideally this should be done recursively until
# no more packages are found, but that's hard to do in make, so limit to
# 1 level for now.
HOST_DEPS = $(sort $(foreach dep,\
		$(addsuffix _DEPENDENCIES,$(call UPPERCASE,$(TARGETS_HOST_DEPS))),\
		$($(dep))))
HOST_SOURCE += $(addsuffix -source,$(sort $(TARGETS_HOST_DEPS) $(HOST_DEPS)))

TARGETS_LEGAL_INFO := $(patsubst %,%-legal-info,\
		$(TARGETS) $(TARGETS_HOST_DEPS) $(HOST_DEPS))))

dirs: $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) \
	$(HOST_DIR) $(BINARIES_DIR)

$(BUILD_DIR)/buildroot-config/auto.conf: $(BR2_CONFIG)
	$(MAKE1) $(EXTRAMAKEARGS) HOSTCC="$(HOSTCC_NOCCACHE)" HOSTCXX="$(HOSTCXX_NOCCACHE)" silentoldconfig

prepare: $(BUILD_DIR)/buildroot-config/auto.conf

world: target-post-image

.PHONY: all world toolchain dirs clean distclean source outputmakefile \
	legal-info legal-info-prepare legal-info-clean printvars \
	target-finalize target-post-image \
	$(TARGETS) $(TARGETS_ROOTFS) \
	$(TARGETS_DIRCLEAN) $(TARGETS_SOURCE) $(TARGETS_LEGAL_INFO) \
	$(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) \
	$(HOST_DIR) $(BINARIES_DIR)

################################################################################
#
# staging and target directories do NOT list these as
# dependencies anywhere else
#
################################################################################
$(BUILD_DIR) $(HOST_DIR) $(BINARIES_DIR) $(LEGAL_INFO_DIR) $(REDIST_SOURCES_DIR_TARGET) $(REDIST_SOURCES_DIR_HOST):
	@mkdir -p $@

# We make a symlink lib32->lib or lib64->lib as appropriate
# MIPS64/n32 requires lib32 even though it's a 64-bit arch.
ifeq ($(BR2_ARCH_IS_64)$(BR2_MIPS_NABI32),y)
LIB_SYMLINK = lib64
else
LIB_SYMLINK = lib32
endif

$(STAGING_DIR):
	@mkdir -p $(STAGING_DIR)/bin
	@mkdir -p $(STAGING_DIR)/lib
	@ln -snf lib $(STAGING_DIR)/$(LIB_SYMLINK)
	@mkdir -p $(STAGING_DIR)/usr/lib
	@ln -snf lib $(STAGING_DIR)/usr/$(LIB_SYMLINK)
	@mkdir -p $(STAGING_DIR)/usr/include
	@mkdir -p $(STAGING_DIR)/usr/bin
	@ln -snf $(STAGING_DIR) $(BASE_DIR)/staging

ifeq ($(BR2_ROOTFS_SKELETON_CUSTOM),y)
TARGET_SKELETON = $(BR2_ROOTFS_SKELETON_CUSTOM_PATH)
endif

RSYNC_VCS_EXCLUSIONS = \
	--exclude .svn --exclude .git --exclude .hg --exclude .bzr \
	--exclude CVS

$(BUILD_DIR)/.root:
	mkdir -p $(TARGET_DIR)
	rsync -a --ignore-times $(RSYNC_VCS_EXCLUSIONS) \
		--chmod=Du+w --exclude .empty --exclude '*~' \
		$(TARGET_SKELETON)/ $(TARGET_DIR)/
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt $(TARGET_DIR_WARNING_FILE)
	@ln -snf lib $(TARGET_DIR)/$(LIB_SYMLINK)
	@mkdir -p $(TARGET_DIR)/usr
	@ln -snf lib $(TARGET_DIR)/usr/$(LIB_SYMLINK)
	touch $@

$(TARGET_DIR): $(BUILD_DIR)/.root

STRIP_FIND_CMD = find $(TARGET_DIR)
ifneq (,$(call qstrip,$(BR2_STRIP_EXCLUDE_DIRS)))
STRIP_FIND_CMD += \( $(call finddirclauses,$(TARGET_DIR),$(call qstrip,$(BR2_STRIP_EXCLUDE_DIRS))) \) -prune -o
endif
STRIP_FIND_CMD += -type f \( -perm /111 -o -name '*.so*' \)
# file exclusions:
# - libpthread.so: a non-stripped libpthread shared library is needed for
#   proper debugging of pthread programs using gdb.
# - kernel modules (*.ko): do not function properly when stripped like normal
#   applications and libraries. Normally kernel modules are already excluded
#   by the executable permission check above, so the explicit exclusion is only
#   done for kernel modules with incorrect permissions.
STRIP_FIND_CMD += -not \( $(call findfileclauses,libpthread*.so* *.ko $(call qstrip,$(BR2_STRIP_EXCLUDE_FILES))) \) -print

ifeq ($(BR2_ECLIPSE_REGISTER),y)
define TOOLCHAIN_ECLIPSE_REGISTER
	./support/scripts/eclipse-register-toolchain `readlink -f $(O)` \
		$(notdir $(TARGET_CROSS)) $(BR2_ARCH)
endef
TARGET_FINALIZE_HOOKS += TOOLCHAIN_ECLIPSE_REGISTER
endif

# Generate locale data. Basically, we call the localedef program
# (built by the host-localedef package) for each locale. The input
# data comes preferably from the toolchain, or if the toolchain does
# not have them (Linaro toolchains), we use the ones available on the
# host machine.
ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
GENERATE_LOCALE = $(call qstrip,$(BR2_GENERATE_LOCALE))
ifneq ($(GENERATE_LOCALE),)
TARGETS += host-localedef

define GENERATE_LOCALES
	$(Q)mkdir -p $(TARGET_DIR)/usr/lib/locale/
	$(Q)for locale in $(GENERATE_LOCALE) ; do \
		inputfile=`echo $${locale} | cut -f1 -d'.'` ; \
		charmap=`echo $${locale} | cut -f2 -d'.' -s` ; \
		if test -z "$${charmap}" ; then \
			charmap="UTF-8" ; \
		fi ; \
		echo "Generating locale $${inputfile}.$${charmap}" ; \
		I18NPATH=$(STAGING_DIR)/usr/share/i18n:/usr/share/i18n \
		$(HOST_DIR)/usr/bin/localedef \
			--prefix=$(TARGET_DIR) \
			--$(call LOWERCASE,$(BR2_ENDIAN))-endian \
			-i $${inputfile} -f $${charmap} \
			$${locale} ; \
	done
endef
TARGET_FINALIZE_HOOKS += GENERATE_LOCALES
endif
endif

ifeq ($(BR2_ENABLE_LOCALE_PURGE),y)
LOCALE_WHITELIST = $(BUILD_DIR)/locales.nopurge
LOCALE_NOPURGE = $(call qstrip,$(BR2_ENABLE_LOCALE_WHITELIST))

define PURGE_LOCALES
	rm -f $(LOCALE_WHITELIST)
	for i in $(LOCALE_NOPURGE) locale-archive; do echo $$i >> $(LOCALE_WHITELIST); done

	for dir in $(wildcard $(addprefix $(TARGET_DIR),/usr/share/locale /usr/share/X11/locale /usr/man /usr/share/man /usr/lib/locale)); \
	do \
		for lang in $$(cd $$dir; ls .|grep -v man); \
		do \
			grep -qx $$lang $(LOCALE_WHITELIST) || rm -rf $$dir/$$lang; \
		done; \
	done
endef
TARGET_FINALIZE_HOOKS += PURGE_LOCALES
endif

$(TARGETS_ROOTFS): target-finalize

target-finalize: $(TARGETS)
	@$(call MESSAGE,"Finalizing target directory")
	$(foreach hook,$(TARGET_FINALIZE_HOOKS),$($(hook))$(sep))
	rm -rf $(TARGET_DIR)/usr/include $(TARGET_DIR)/usr/share/aclocal \
		$(TARGET_DIR)/usr/lib/pkgconfig $(TARGET_DIR)/usr/share/pkgconfig \
		$(TARGET_DIR)/usr/lib/cmake $(TARGET_DIR)/usr/share/cmake
	find $(TARGET_DIR)/usr/{lib,share}/ -name '*.cmake' -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/usr/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
ifneq ($(BR2_PACKAGE_GDB),y)
	rm -rf $(TARGET_DIR)/usr/share/gdb
endif
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/man
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/share/info
	rm -rf $(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/doc
	rm -rf $(TARGET_DIR)/usr/share/gtk-doc
	-rmdir $(TARGET_DIR)/usr/share 2>/dev/null
ifeq ($(BR2_PACKAGE_PYTHON_PY_ONLY)$(BR2_PACKAGE_PYTHON3_PY_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.pyc' -print0 | xargs -0 rm -f
endif
ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY)$(BR2_PACKAGE_PYTHON3_PYC_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.py' -print0 | xargs -0 rm -f
endif
	$(STRIP_FIND_CMD) | xargs $(STRIPCMD) 2>/dev/null || true
	if test -d $(TARGET_DIR)/lib/modules; then \
		find $(TARGET_DIR)/lib/modules -type f -name '*.ko' | \
		xargs -r $(KSTRIPCMD); fi

# See http://sourceware.org/gdb/wiki/FAQ, "GDB does not see any threads
# besides the one in which crash occurred; or SIGTRAP kills my program when
# I set a breakpoint"
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
	find $(TARGET_DIR)/lib -type f -name 'libpthread*.so*' | \
		xargs -r $(STRIPCMD) $(STRIP_STRIP_DEBUG)
endif

	mkdir -p $(TARGET_DIR)/etc
	# Mandatory configuration file and auxilliary cache directory
	# for recent versions of ldconfig
	touch $(TARGET_DIR)/etc/ld.so.conf
	mkdir -p $(TARGET_DIR)/var/cache/ldconfig
	if [ -x "$(TARGET_CROSS)ldconfig" ]; \
	then \
		$(TARGET_CROSS)ldconfig -r $(TARGET_DIR); \
	else \
		/sbin/ldconfig -r $(TARGET_DIR); \
	fi
	( \
		echo "NAME=Buildroot"; \
		echo "VERSION=$(BR2_VERSION_FULL)"; \
		echo "ID=buildroot"; \
		echo "VERSION_ID=$(BR2_VERSION)"; \
		echo "PRETTY_NAME=\"Buildroot $(BR2_VERSION)\"" \
	) >  $(TARGET_DIR)/etc/os-release

	@$(foreach d, $(call qstrip,$(BR2_ROOTFS_OVERLAY)), \
		$(call MESSAGE,"Copying overlay $(d)"); \
		rsync -a --ignore-times $(RSYNC_VCS_EXCLUSIONS) \
			--chmod=Du+w --exclude .empty --exclude '*~' \
			$(d)/ $(TARGET_DIR)$(sep))

	@$(foreach s, $(call qstrip,$(BR2_ROOTFS_POST_BUILD_SCRIPT)), \
		$(call MESSAGE,"Executing post-build script $(s)"); \
		$(EXTRA_ENV) $(s) $(TARGET_DIR) $(call qstrip,$(BR2_ROOTFS_POST_SCRIPT_ARGS))$(sep))

target-post-image: $(TARGETS_ROOTFS) target-finalize
	@$(foreach s, $(call qstrip,$(BR2_ROOTFS_POST_IMAGE_SCRIPT)), \
		$(call MESSAGE,"Executing post-image script $(s)"); \
		$(EXTRA_ENV) $(s) $(BINARIES_DIR) $(call qstrip,$(BR2_ROOTFS_POST_SCRIPT_ARGS))$(sep))

source: $(TARGETS_SOURCE) $(HOST_SOURCE)

external-deps:
	@$(MAKE1) -Bs DL_MODE=SHOW_EXTERNAL_DEPS $(EXTRAMAKEARGS) source | sort -u

legal-info-clean:
	@rm -fr $(LEGAL_INFO_DIR)

legal-info-prepare: $(LEGAL_INFO_DIR)
	@$(call MESSAGE,"Collecting legal info")
	@$(call legal-license-file,buildroot,COPYING,COPYING,HOST)
	@$(call legal-manifest,PACKAGE,VERSION,LICENSE,LICENSE FILES,SOURCE ARCHIVE,SOURCE SITE,TARGET)
	@$(call legal-manifest,PACKAGE,VERSION,LICENSE,LICENSE FILES,SOURCE ARCHIVE,SOURCE SITE,HOST)
	@$(call legal-manifest,buildroot,$(BR2_VERSION_FULL),GPLv2+,COPYING,not saved,not saved,HOST)
	@$(call legal-warning,the Buildroot source code has not been saved)
	@$(call legal-warning,the toolchain has not been saved)
	@cp $(BR2_CONFIG) $(LEGAL_INFO_DIR)/buildroot.config

legal-info: dirs legal-info-clean legal-info-prepare $(TARGETS_LEGAL_INFO) \
		$(REDIST_SOURCES_DIR_TARGET) $(REDIST_SOURCES_DIR_HOST)
	@cat support/legal-info/README.header >>$(LEGAL_REPORT)
	@if [ -r $(LEGAL_WARNINGS) ]; then \
		cat support/legal-info/README.warnings-header \
			$(LEGAL_WARNINGS) >>$(LEGAL_REPORT); \
		cat $(LEGAL_WARNINGS); fi
	@echo "Legal info produced in $(LEGAL_INFO_DIR)"
	@rm -f $(LEGAL_WARNINGS)

show-targets:
	@echo $(HOST_DEPS) $(TARGETS_HOST_DEPS) $(TARGETS) $(TARGETS_ROOTFS)

graph-build: $(O)/build/build-time.log
	@install -d $(O)/graphs
	$(foreach o,name build duration,./support/scripts/graph-build-time \
					--type=histogram --order=$(o) --input=$(<) \
					--output=$(O)/graphs/build.hist-$(o).$(BR_GRAPH_OUT) \
					$(if $(BR2_GRAPH_ALT),--alternate-colors)$(sep))
	$(foreach t,packages steps,./support/scripts/graph-build-time \
				   --type=pie-$(t) --input=$(<) \
				   --output=$(O)/graphs/build.pie-$(t).$(BR_GRAPH_OUT) \
				   $(if $(BR2_GRAPH_ALT),--alternate-colors)$(sep))

graph-depends-requirements:
	@dot -? >/dev/null 2>&1 || \
		{ echo "ERROR: The 'dot' program from Graphviz is needed for graph-depends" >&2; exit 1; }

graph-depends: graph-depends-requirements
	@$(INSTALL) -d $(O)/graphs
	@cd "$(CONFIG_DIR)"; \
	$(TOPDIR)/support/scripts/graph-depends $(BR2_GRAPH_DEPS_OPTS) \
	|tee $(BASE_DIR)/graphs/$(@).dot \
	|dot $(BR2_GRAPH_DOT_OPTS) -T$(BR_GRAPH_OUT) -o $(BASE_DIR)/graphs/$(@).$(BR_GRAPH_OUT)

else # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

all: menuconfig

endif # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

# configuration
# ---------------------------------------------------------------------------

HOSTCFLAGS = $(CFLAGS_FOR_BUILD)
export HOSTCFLAGS

$(BUILD_DIR)/buildroot-config/%onf:
	mkdir -p $(@D)/lxdialog
	$(MAKE) CC="$(HOSTCC_NOCCACHE)" HOSTCC="$(HOSTCC_NOCCACHE)" obj=$(@D) -C $(CONFIG) -f Makefile.br $(@F)

DEFCONFIG = $(call qstrip,$(BR2_DEFCONFIG))

# We don't want to fully expand BR2_DEFCONFIG here, so Kconfig will
# recognize that if it's still at its default $(CONFIG_DIR)/defconfig
COMMON_CONFIG_ENV = \
	BR2_DEFCONFIG='$(call qstrip,$(value BR2_DEFCONFIG))' \
	KCONFIG_AUTOCONFIG=$(BUILD_DIR)/buildroot-config/auto.conf \
	KCONFIG_AUTOHEADER=$(BUILD_DIR)/buildroot-config/autoconf.h \
	KCONFIG_TRISTATE=$(BUILD_DIR)/buildroot-config/tristate.config \
	BR2_CONFIG=$(BR2_CONFIG) \
	BR2_EXTERNAL=$(BR2_EXTERNAL)

xconfig: $(BUILD_DIR)/buildroot-config/qconf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

gconfig: $(BUILD_DIR)/buildroot-config/gconf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) srctree=$(TOPDIR) $< $(CONFIG_CONFIG_IN)

menuconfig: $(BUILD_DIR)/buildroot-config/mconf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

nconfig: $(BUILD_DIR)/buildroot-config/nconf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

config: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

oldconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --oldconfig $(CONFIG_CONFIG_IN)

randconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --randconfig $(CONFIG_CONFIG_IN)

allyesconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --allyesconfig $(CONFIG_CONFIG_IN)

allnoconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --allnoconfig $(CONFIG_CONFIG_IN)

randpackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@grep '^config BR2_PACKAGE_' Config.in.legacy | \
		while read config pkg; do \
		echo "# $$pkg is not set" >> $(CONFIG_DIR)/.config.nopkg; done
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --randconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

allyespackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@grep '^config BR2_PACKAGE_' Config.in.legacy | \
		while read config pkg; do \
		echo "# $$pkg is not set" >> $(CONFIG_DIR)/.config.nopkg; done
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allyesconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

allnopackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allnoconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

silentoldconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	$(COMMON_CONFIG_ENV) $< --silentoldconfig $(CONFIG_CONFIG_IN)

olddefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN)

defconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --defconfig$(if $(DEFCONFIG),=$(DEFCONFIG)) $(CONFIG_CONFIG_IN)

%_defconfig: $(BUILD_DIR)/buildroot-config/conf $(TOPDIR)/configs/%_defconfig outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --defconfig=$(TOPDIR)/configs/$@ $(CONFIG_CONFIG_IN)

%_defconfig: $(BUILD_DIR)/buildroot-config/conf $(BR2_EXTERNAL)/configs/%_defconfig outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --defconfig=$(BR2_EXTERNAL)/configs/$@ $(CONFIG_CONFIG_IN)

savedefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< \
		--savedefconfig=$(if $(DEFCONFIG),$(DEFCONFIG),$(CONFIG_DIR)/defconfig) \
		$(CONFIG_CONFIG_IN)

# check if download URLs are outdated
source-check:
	$(MAKE1) DL_MODE=SOURCE_CHECK $(EXTRAMAKEARGS) source

.PHONY: defconfig savedefconfig

################################################################################
#
# Cleanup and misc junk
#
################################################################################

# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.
outputmakefile:
ifeq ($(NEED_WRAPPER),y)
	$(Q)$(TOPDIR)/support/scripts/mkmakefile $(TOPDIR) $(O)
endif

# printvars prints all the variables currently defined in our Makefiles
printvars:
	@$(foreach V, \
		$(sort $(.VARIABLES)), \
		$(if $(filter-out environment% default automatic, \
				$(origin $V)), \
		$(info $V=$($V) ($(value $V)))))

clean:
	rm -rf $(TARGET_DIR) $(BINARIES_DIR) $(HOST_DIR) \
		$(BUILD_DIR) $(BASE_DIR)/staging \
		$(LEGAL_INFO_DIR)

distclean: clean
ifeq ($(DL_DIR),$(TOPDIR)/dl)
	rm -rf $(DL_DIR)
endif
ifeq ($(O),output)
	rm -rf $(O)
endif
	rm -rf $(BR2_CONFIG) $(CONFIG_DIR)/.config.old $(CONFIG_DIR)/.auto.deps

help:
	@echo 'Cleaning:'
	@echo '  clean                  - delete all files created by build'
	@echo '  distclean              - delete all non-source files (including .config)'
	@echo
	@echo 'Build:'
	@echo '  all                    - make world'
	@echo '  toolchain              - build toolchain'
	@echo '  <package>-rebuild      - force recompile <package>'
	@echo '  <package>-reconfigure  - force reconfigure <package>'
	@echo '  <package>-graph-depends    - generate graph of the dependency tree for package'
	@echo
	@echo 'Configuration:'
	@echo '  menuconfig             - interactive curses-based configurator'
	@echo '  nconfig                - interactive ncurses-based configurator'
	@echo '  xconfig                - interactive Qt-based configurator'
	@echo '  gconfig                - interactive GTK-based configurator'
	@echo '  oldconfig              - resolve any unresolved symbols in .config'
	@echo '  silentoldconfig        - Same as oldconfig, but quietly, additionally update deps'
	@echo '  olddefconfig           - Same as silentoldconfig but sets new symbols to their default value'
	@echo '  randconfig             - New config with random answer to all options'
	@echo '  defconfig              - New config with default answer to all options'
	@echo '                             BR2_DEFCONFIG, if set, is used as input'
	@echo '  savedefconfig          - Save current config as ./defconfig (minimal config)'
	@echo '  allyesconfig           - New config where all options are accepted with yes'
	@echo '  allnoconfig            - New config where all options are answered with no'
	@echo '  randpackageconfig      - New config with random answer to package options'
	@echo '  allyespackageconfig    - New config where pkg options are accepted with yes'
	@echo '  allnopackageconfig     - New config where package options are answered with no'
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	@echo '  busybox-menuconfig     - Run BusyBox menuconfig'
endif
ifeq ($(BR2_LINUX_KERNEL),y)
	@echo '  linux-menuconfig       - Run Linux kernel menuconfig'
	@echo '  linux-savedefconfig    - Run Linux kernel savedefconfig'
endif
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
	@echo '  uclibc-menuconfig      - Run uClibc menuconfig'
endif
ifeq ($(BR2_TARGET_BAREBOX),y)
	@echo '  barebox-menuconfig     - Run barebox menuconfig'
	@echo '  barebox-savedefconfig  - Run barebox savedefconfig'
endif
	@echo
	@echo 'Documentation:'
	@echo '  manual                 - build manual in all formats'
	@echo '  manual-html            - build manual in HTML'
	@echo '  manual-split-html      - build manual in split HTML'
	@echo '  manual-pdf             - build manual in PDF'
	@echo '  manual-text            - build manual in text'
	@echo '  manual-epub            - build manual in ePub'
	@echo '  graph-build            - generate graphs of the build times'
	@echo '  graph-depends          - generate graph of the dependency tree'
	@echo
	@echo 'Miscellaneous:'
	@echo '  source                 - download all sources needed for offline-build'
	@echo '  source-check           - check selected packages for valid download URLs'
	@echo '  external-deps          - list external packages used'
	@echo '  legal-info             - generate info about license compliance'
	@echo
	@echo '  make V=0|1             - 0 => quiet build (default), 1 => verbose build'
	@echo '  make O=dir             - Locate all output files in "dir", including .config'
	@echo
	@echo 'Built-in configs:'
	@$(foreach b, $(sort $(notdir $(wildcard $(TOPDIR)/configs/*_defconfig))), \
	  printf "  %-35s - Build for %s\\n" $(b) $(b:_defconfig=);)
ifneq ($(wildcard $(BR2_EXTERNAL)/configs/*_defconfig),)
	@echo
	@echo 'User-provided configs:'
	@$(foreach b, $(sort $(notdir $(wildcard $(BR2_EXTERNAL)/configs/*_defconfig))), \
	  printf "  %-35s - Build for %s\\n" $(b) $(b:_defconfig=);)
endif
	@echo
	@echo 'See docs/README, or generate the Buildroot manual for further details'
	@echo

release: OUT = buildroot-$(BR2_VERSION)

# Create release tarballs. We need to fiddle a bit to add the generated
# documentation to the git output
release:
	git archive --format=tar --prefix=$(OUT)/ HEAD > $(OUT).tar
	$(MAKE) O=$(OUT) manual-html manual-text manual-pdf
	tar rf $(OUT).tar $(OUT)
	gzip -9 -c < $(OUT).tar > $(OUT).tar.gz
	bzip2 -9 -c < $(OUT).tar > $(OUT).tar.bz2
	rm -rf $(OUT) $(OUT).tar

print-version:
	@echo $(BR2_VERSION_FULL)

include docs/manual/manual.mk

.PHONY: $(noconfig_targets)
