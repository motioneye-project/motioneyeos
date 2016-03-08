# Makefile for buildroot
#
# Copyright (C) 1999-2005 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2006-2014 by the Buildroot developers <buildroot@uclibc.org>
# Copyright (C) 2014-2016 by the Buildroot developers <buildroot@buildroot.org>
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

# Trick for always running with a fixed umask
UMASK = 0022
ifneq ($(shell umask),$(UMASK))
.PHONY: _all $(MAKECMDGOALS)

$(MAKECMDGOALS): _all
	@:

_all:
	@umask $(UMASK) && $(MAKE) --no-print-directory $(MAKECMDGOALS)

else # umask

# This is our default rule, so must come first
all:

# Set and export the version string
export BR2_VERSION := 2016.05-git

# Save running make version since it's clobbered by the make package
RUNNING_MAKE_VERSION := $(MAKE_VERSION)

# Check for minimal make version (note: this check will break at make 10.x)
MIN_MAKE_VERSION = 3.81
ifneq ($(firstword $(sort $(RUNNING_MAKE_VERSION) $(MIN_MAKE_VERSION))),$(MIN_MAKE_VERSION))
$(error You have make '$(RUNNING_MAKE_VERSION)' installed. GNU make >= $(MIN_MAKE_VERSION) is required)
endif

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
# use the -j<jobs> option when building, e.g:
#      make -j$((`getconf _NPROCESSORS_ONLN`+1))
.NOTPARALLEL:

# absolute path
TOPDIR := $(CURDIR)
CONFIG_CONFIG_IN = Config.in
CONFIG = support/kconfig
DATE := $(shell date +%Y%m%d)

# Compute the full local version string so packages can use it as-is
# Need to export it, so it can be got from environment in children (eg. mconf)
export BR2_VERSION_FULL := $(BR2_VERSION)$(shell $(TOPDIR)/support/scripts/setlocalversion)

noconfig_targets := menuconfig nconfig gconfig xconfig config oldconfig randconfig \
	defconfig %_defconfig allyesconfig allnoconfig silentoldconfig release \
	randpackageconfig allyespackageconfig allnopackageconfig \
	print-version olddefconfig

# Some global targets do not trigger a build, but are used to collect
# metadata, or do various checks. When such targets are triggered,
# some packages should not do their configuration sanity
# checks. Provide them a BR_BUILDING variable set to 'y' when we're
# actually building and they should do their sanity checks.
#
# We're building in two situations: when MAKECMDGOALS is empty
# (default target is to build), or when MAKECMDGOALS contains
# something else than one of the nobuild_targets.
nobuild_targets := source source-check \
	legal-info external-deps _external-deps \
	clean distclean help
ifeq ($(MAKECMDGOALS),)
BR_BUILDING = y
else ifneq ($(filter-out $(nobuild_targets),$(MAKECMDGOALS)),)
BR_BUILDING = y
endif

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
# When BR2_EXTERNAL is set to an empty value (e.g. explicitly in command
# line), the .br-external file is removed and we point to
# support/dummy-external. This makes sure we can unconditionally include the
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

# To make sure that the environment variable overrides the .config option,
# set this before including .config.
ifneq ($(BR2_DL_DIR),)
DL_DIR := $(BR2_DL_DIR)
endif
ifneq ($(BR2_CCACHE_DIR),)
BR_CACHE_DIR := $(BR2_CCACHE_DIR)
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
GRAPHS_DIR := $(BASE_DIR)/graphs

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
ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
  Q =
ifndef VERBOSE
  VERBOSE = 1
endif
export VERBOSE
else
  Q = @
endif

# we want bash as shell
SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	 else if [ -x /bin/bash ]; then echo /bin/bash; \
	 else echo sh; fi; fi)

# kconfig uses CONFIG_SHELL
CONFIG_SHELL := $(SHELL)

export SHELL CONFIG_SHELL Q KBUILD_VERBOSE

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
HOSTCPP := $(shell which $(HOSTCPP) || type -p $(HOSTCPP) || echo cpp)
HOSTLD := $(shell which $(HOSTLD) || type -p $(HOSTLD) || echo ld)
HOSTLN := $(shell which $(HOSTLN) || type -p $(HOSTLN) || echo ln)
HOSTNM := $(shell which $(HOSTNM) || type -p $(HOSTNM) || echo nm)
HOSTOBJCOPY := $(shell which $(HOSTOBJCOPY) || type -p $(HOSTOBJCOPY) || echo objcopy)
HOSTRANLIB := $(shell which $(HOSTRANLIB) || type -p $(HOSTRANLIB) || echo ranlib)

export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTLD
export HOSTCC_NOCCACHE HOSTCXX_NOCCACHE

# Determine the userland we are running on.
#
# Note that, despite its name, we are not interested in the actual
# architecture name. This is mostly used to determine whether some
# of the binary tools (e.g. pre-built external toolchains) can run
# on the current host. So we need to know if the userland we're
# running on can actually run those toolchains.
#
# For example, a 64-bit prebuilt toolchain will not run on a 64-bit
# kernel if the userland is 32-bit (e.g. in a chroot for example).
#
# So, we extract the first part of the tuple the host gcc was
# configured to generate code for; we assume this is our userland.
#
export HOSTARCH := $(shell LC_ALL=C $(HOSTCC_NOCCACHE) -v 2>&1 | \
	sed -e '/^Target: \([^-]*\).*/!d' \
	    -e 's//\1/' \
	    -e 's/i.86/x86/' \
	    -e 's/sun4u/sparc64/' \
	    -e 's/arm.*/arm/' \
	    -e 's/sa110/arm/' \
	    -e 's/ppc64/powerpc64/' \
	    -e 's/ppc/powerpc/' \
	    -e 's/macppc/powerpc/' \
	    -e 's/sh.*/sh/' )

HOSTCC_VERSION := $(shell $(HOSTCC_NOCCACHE) --version | \
	sed -n -r 's/^.* ([0-9]*)\.([0-9]*)\.([0-9]*)[ ]*.*/\1 \2/p')

# For gcc >= 5.x, we only need the major version.
ifneq ($(firstword $(HOSTCC_VERSION)),4)
HOSTCC_VERSION := $(firstword $(HOSTCC_VERSION))
endif

# Make sure pkg-config doesn't look outside the buildroot tree
HOST_PKG_CONFIG_PATH := $(PKG_CONFIG_PATH)
unexport PKG_CONFIG_PATH
unexport PKG_CONFIG_SYSROOT_DIR
unexport PKG_CONFIG_LIBDIR

# Having DESTDIR set in the environment confuses the installation
# steps of some packages.
unexport DESTDIR

# Causes breakage with packages that needs host-ruby
unexport RUBYOPT

include package/pkg-utils.mk
include package/doc-asciidoc.mk

ifeq ($(BR2_HAVE_DOT_CONFIG),y)

################################################################################
#
# Hide troublesome environment variables from sub processes
#
################################################################################
unexport CROSS_COMPILE
unexport ARCH
unexport CC
unexport LD
unexport AR
unexport CXX
unexport CPP
unexport RANLIB
unexport CFLAGS
unexport CXXFLAGS
unexport GREP_OPTIONS
unexport TAR_OPTIONS
unexport CONFIG_SITE
unexport QMAKESPEC
unexport TERMINFO
unexport MACHINE
unexport O

GNU_HOST_NAME := $(shell support/gnuconfig/config.guess)

PACKAGES :=
PACKAGES_ALL :=

# silent mode requested?
QUIET := $(if $(findstring s,$(filter-out --%,$(MAKEFLAGS))),-q)

# Strip off the annoying quoting
ARCH := $(call qstrip,$(BR2_ARCH))

KERNEL_ARCH := $(shell echo "$(ARCH)" | sed -e "s/-.*//" \
	-e s/i.86/i386/ -e s/sun4u/sparc64/ \
	-e s/arcle/arc/ \
	-e s/arceb/arc/ \
	-e s/arm.*/arm/ -e s/sa110/arm/ \
	-e s/aarch64.*/arm64/ \
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

# Location of a file giving a big fat warning that output/target
# should not be used as the root filesystem.
TARGET_DIR_WARNING_FILE = $(TARGET_DIR)/THIS_IS_NOT_YOUR_ROOT_FILESYSTEM

ifeq ($(BR2_CCACHE),y)
CCACHE := $(HOST_DIR)/usr/bin/ccache
BR_CACHE_DIR ?= $(call qstrip,$(BR2_CCACHE_DIR))
export BR_CACHE_DIR
HOSTCC := $(CCACHE) $(HOSTCC)
HOSTCXX := $(CCACHE) $(HOSTCXX)
else
export BR_NO_CCACHE
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
include fs/common.mk

include $(BR2_EXTERNAL)/external.mk

# Now we are sure we have all the packages scanned and defined. We now
# check for each package in the list of enabled packages, that all its
# dependencies are indeed enabled.
#
# Only trigger the check for default builds. If the user forces building
# a package, even if not enabled in the configuration, we want to accept
# it.
#
ifeq ($(MAKECMDGOALS),)

define CHECK_ONE_DEPENDENCY
ifeq ($$($(2)_TYPE),target)
ifeq ($$($(2)_IS_VIRTUAL),)
ifneq ($$($$($(2)_KCONFIG_VAR)),y)
$$(error $$($(2)_NAME) is in the dependency chain of $$($(1)_NAME) that \
has added it to its _DEPENDENCIES variable without selecting it or \
depending on it from Config.in)
endif
endif
endif
endef

$(foreach pkg,$(call UPPERCASE,$(PACKAGES)),\
	$(foreach dep,$(call UPPERCASE,$($(pkg)_FINAL_ALL_DEPENDENCIES)),\
		$(eval $(call CHECK_ONE_DEPENDENCY,$(pkg),$(dep))$(sep))))

endif

dirs: $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) \
	$(HOST_DIR) $(BINARIES_DIR)

$(BUILD_DIR)/buildroot-config/auto.conf: $(BR2_CONFIG)
	$(MAKE1) $(EXTRAMAKEARGS) HOSTCC="$(HOSTCC_NOCCACHE)" HOSTCXX="$(HOSTCXX_NOCCACHE)" silentoldconfig

prepare: $(BUILD_DIR)/buildroot-config/auto.conf

world: target-post-image

.PHONY: all world toolchain dirs clean distclean source outputmakefile \
	legal-info legal-info-prepare legal-info-clean printvars help \
	list-defconfigs target-finalize target-post-image source-check

################################################################################
#
# staging and target directories do NOT list these as
# dependencies anywhere else
#
################################################################################
$(BUILD_DIR) $(TARGET_DIR) $(HOST_DIR) $(BINARIES_DIR) $(LEGAL_INFO_DIR) $(REDIST_SOURCES_DIR_TARGET) $(REDIST_SOURCES_DIR_HOST):
	@mkdir -p $@

# Populating the staging with the base directories is handled by the skeleton package
$(STAGING_DIR):
	@mkdir -p $(STAGING_DIR)
	@ln -snf $(STAGING_DIR) $(BASE_DIR)/staging

RSYNC_VCS_EXCLUSIONS = \
	--exclude .svn --exclude .git --exclude .hg --exclude .bzr \
	--exclude CVS

STRIP_FIND_CMD = find $(TARGET_DIR)
ifneq (,$(call qstrip,$(BR2_STRIP_EXCLUDE_DIRS)))
STRIP_FIND_CMD += \( $(call finddirclauses,$(TARGET_DIR),$(call qstrip,$(BR2_STRIP_EXCLUDE_DIRS))) \) -prune -o
endif
STRIP_FIND_CMD += -type f \( -perm /111 -o -name '*.so*' \)
# file exclusions:
# - libpthread.so: a non-stripped libpthread shared library is needed for
#   proper debugging of pthread programs using gdb.
# - ld.so: a non-stripped dynamic linker library is needed for valgrind
# - kernel modules (*.ko): do not function properly when stripped like normal
#   applications and libraries. Normally kernel modules are already excluded
#   by the executable permission check above, so the explicit exclusion is only
#   done for kernel modules with incorrect permissions.
STRIP_FIND_CMD += -not \( $(call findfileclauses,libpthread*.so* ld-*.so* *.ko $(call qstrip,$(BR2_STRIP_EXCLUDE_FILES))) \) -print0

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
GLIBC_GENERATE_LOCALES = $(call qstrip,$(BR2_GENERATE_LOCALE))
ifneq ($(GLIBC_GENERATE_LOCALES),)
PACKAGES += host-localedef

define GENERATE_GLIBC_LOCALES
	$(Q)mkdir -p $(TARGET_DIR)/usr/lib/locale/
	$(Q)for locale in $(GLIBC_GENERATE_LOCALES) ; do \
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
TARGET_FINALIZE_HOOKS += GENERATE_GLIBC_LOCALES
endif
endif

ifeq ($(BR2_ENABLE_LOCALE_PURGE),y)
LOCALE_WHITELIST = $(BUILD_DIR)/locales.nopurge
LOCALE_NOPURGE = $(call qstrip,$(BR2_ENABLE_LOCALE_WHITELIST))

# This piece of junk does the following:
# First collect the whitelist in a file.
# Then go over all the locale dirs and for each subdir, check if it exists
# in the whitelist file. If it doesn't, kill it.
# Finally, specifically for X11, regenerate locale.dir from the whitelist.
define PURGE_LOCALES
	rm -f $(LOCALE_WHITELIST)
	for i in $(LOCALE_NOPURGE) locale-archive; do echo $$i >> $(LOCALE_WHITELIST); done

	for dir in $(wildcard $(addprefix $(TARGET_DIR),/usr/share/locale /usr/share/X11/locale /usr/lib/locale)); \
	do \
		for langdir in $$dir/*; \
		do \
			if [ -e "$${langdir}" ]; \
			then \
				grep -qx "$${langdir##*/}" $(LOCALE_WHITELIST) || rm -rf $$langdir; \
			fi \
		done; \
	done
	if [ -d $(TARGET_DIR)/usr/share/X11/locale ]; \
	then \
		for lang in $(LOCALE_NOPURGE); \
		do \
			if [ -f $(TARGET_DIR)/usr/share/X11/locale/$$lang/XLC_LOCALE ]; \
			then \
				echo "$$lang/XLC_LOCALE: $$lang"; \
			fi \
		done > $(TARGET_DIR)/usr/share/X11/locale/locale.dir; \
	fi
endef
TARGET_FINALIZE_HOOKS += PURGE_LOCALES
endif

$(TARGETS_ROOTFS): target-finalize

target-finalize: $(PACKAGES)
	@$(call MESSAGE,"Finalizing target directory")
	$(foreach hook,$(TARGET_FINALIZE_HOOKS),$($(hook))$(sep))
	rm -rf $(TARGET_DIR)/usr/include $(TARGET_DIR)/usr/share/aclocal \
		$(TARGET_DIR)/usr/lib/pkgconfig $(TARGET_DIR)/usr/share/pkgconfig \
		$(TARGET_DIR)/usr/lib/cmake $(TARGET_DIR)/usr/share/cmake
	find $(TARGET_DIR)/usr/{lib,share}/ -name '*.cmake' -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/lib $(TARGET_DIR)/usr/lib $(TARGET_DIR)/usr/libexec \
		\( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
ifneq ($(BR2_PACKAGE_GDB),y)
	rm -rf $(TARGET_DIR)/usr/share/gdb
endif
ifneq ($(BR2_PACKAGE_BASH),y)
	rm -rf $(TARGET_DIR)/usr/share/bash-completion
endif
ifneq ($(BR2_PACKAGE_ZSH),y)
	rm -rf $(TARGET_DIR)/usr/share/zsh
endif
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/man
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/share/info
	rm -rf $(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/doc
	rm -rf $(TARGET_DIR)/usr/share/gtk-doc
	-rmdir $(TARGET_DIR)/usr/share 2>/dev/null
	$(STRIP_FIND_CMD) | xargs -0 $(STRIPCMD) 2>/dev/null || true
	if test -d $(TARGET_DIR)/lib/modules; then \
		find $(TARGET_DIR)/lib/modules -type f -name '*.ko' -print0 | \
		xargs -0 -r $(KSTRIPCMD); fi

# See http://sourceware.org/gdb/wiki/FAQ, "GDB does not see any threads
# besides the one in which crash occurred; or SIGTRAP kills my program when
# I set a breakpoint"
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
	find $(TARGET_DIR)/lib -type f -name 'libpthread*.so*' | \
		xargs -r $(STRIPCMD) $(STRIP_STRIP_DEBUG)
endif

# Valgrind needs ld.so with enough information, so only strip
# debugging symbols.
	find $(TARGET_DIR)/lib -type f -name 'ld-*.so*' | \
		xargs -r $(STRIPCMD) $(STRIP_STRIP_DEBUG)
	test -f $(TARGET_DIR)/etc/ld.so.conf && \
		{ echo "ERROR: we shouldn't have a /etc/ld.so.conf file"; exit 1; } || true
	test -d $(TARGET_DIR)/etc/ld.so.conf.d && \
		{ echo "ERROR: we shouldn't have a /etc/ld.so.conf.d directory"; exit 1; } || true
	mkdir -p $(TARGET_DIR)/etc
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
			--chmod=u=rwX,go=rX --exclude .empty --exclude '*~' \
			$(d)/ $(TARGET_DIR)$(sep))

	@$(foreach s, $(call qstrip,$(BR2_ROOTFS_POST_BUILD_SCRIPT)), \
		$(call MESSAGE,"Executing post-build script $(s)"); \
		$(EXTRA_ENV) $(s) $(TARGET_DIR) $(call qstrip,$(BR2_ROOTFS_POST_SCRIPT_ARGS))$(sep))

target-post-image: $(TARGETS_ROOTFS) target-finalize
	@$(foreach s, $(call qstrip,$(BR2_ROOTFS_POST_IMAGE_SCRIPT)), \
		$(call MESSAGE,"Executing post-image script $(s)"); \
		$(EXTRA_ENV) $(s) $(BINARIES_DIR) $(call qstrip,$(BR2_ROOTFS_POST_SCRIPT_ARGS))$(sep))

source: $(foreach p,$(PACKAGES),$(p)-all-source)

_external-deps: $(foreach p,$(PACKAGES),$(p)-all-external-deps)
external-deps:
	@$(MAKE1) -Bs $(EXTRAMAKEARGS) _external-deps | sort -u

# check if download URLs are outdated
source-check: $(foreach p,$(PACKAGES),$(p)-all-source-check)

legal-info-clean:
	@rm -fr $(LEGAL_INFO_DIR)

legal-info-prepare: $(LEGAL_INFO_DIR)
	@$(call MESSAGE,"Collecting legal info")
	@$(call legal-license-file,buildroot,COPYING,COPYING,HOST)
	@$(call legal-manifest,PACKAGE,VERSION,LICENSE,LICENSE FILES,SOURCE ARCHIVE,SOURCE SITE,TARGET)
	@$(call legal-manifest,PACKAGE,VERSION,LICENSE,LICENSE FILES,SOURCE ARCHIVE,SOURCE SITE,HOST)
	@$(call legal-manifest,buildroot,$(BR2_VERSION_FULL),GPLv2+,COPYING,not saved,not saved,HOST)
	@$(call legal-warning,the Buildroot source code has not been saved)
	@cp $(BR2_CONFIG) $(LEGAL_INFO_DIR)/buildroot.config

legal-info: dirs legal-info-clean legal-info-prepare $(foreach p,$(PACKAGES),$(p)-all-legal-info) \
		$(REDIST_SOURCES_DIR_TARGET) $(REDIST_SOURCES_DIR_HOST)
	@cat support/legal-info/README.header >>$(LEGAL_REPORT)
	@if [ -r $(LEGAL_WARNINGS) ]; then \
		cat support/legal-info/README.warnings-header \
			$(LEGAL_WARNINGS) >>$(LEGAL_REPORT); \
		cat $(LEGAL_WARNINGS); fi
	@echo "Legal info produced in $(LEGAL_INFO_DIR)"
	@rm -f $(LEGAL_WARNINGS)

show-targets:
	@echo $(PACKAGES) $(TARGETS_ROOTFS)

graph-build: $(O)/build/build-time.log
	@install -d $(GRAPHS_DIR)
	$(foreach o,name build duration,./support/scripts/graph-build-time \
					--type=histogram --order=$(o) --input=$(<) \
					--output=$(GRAPHS_DIR)/build.hist-$(o).$(BR_GRAPH_OUT) \
					$(if $(BR2_GRAPH_ALT),--alternate-colors)$(sep))
	$(foreach t,packages steps,./support/scripts/graph-build-time \
				   --type=pie-$(t) --input=$(<) \
				   --output=$(GRAPHS_DIR)/build.pie-$(t).$(BR_GRAPH_OUT) \
				   $(if $(BR2_GRAPH_ALT),--alternate-colors)$(sep))

graph-depends-requirements:
	@dot -? >/dev/null 2>&1 || \
		{ echo "ERROR: The 'dot' program from Graphviz is needed for graph-depends" >&2; exit 1; }

graph-depends: graph-depends-requirements
	@$(INSTALL) -d $(GRAPHS_DIR)
	@cd "$(CONFIG_DIR)"; \
	$(TOPDIR)/support/scripts/graph-depends $(BR2_GRAPH_DEPS_OPTS) \
		-o $(GRAPHS_DIR)/$(@).dot
	dot $(BR2_GRAPH_DOT_OPTS) -T$(BR_GRAPH_OUT) \
		-o $(GRAPHS_DIR)/$(@).$(BR_GRAPH_OUT) \
		$(GRAPHS_DIR)/$(@).dot

graph-size:
	$(Q)mkdir -p $(GRAPHS_DIR)
	$(Q)$(TOPDIR)/support/scripts/size-stats --builddir $(BASE_DIR) \
		--graph $(GRAPHS_DIR)/graph-size.$(BR_GRAPH_OUT) \
		--file-size-csv $(GRAPHS_DIR)/file-size-stats.csv \
		--package-size-csv $(GRAPHS_DIR)/package-size-stats.csv

check-dependencies:
	@cd "$(CONFIG_DIR)"; \
	$(TOPDIR)/support/scripts/graph-depends -C

else # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

all: menuconfig

endif # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

# configuration
# ---------------------------------------------------------------------------

HOSTCFLAGS = $(CFLAGS_FOR_BUILD)
export HOSTCFLAGS

$(BUILD_DIR)/buildroot-config/%onf:
	mkdir -p $(@D)/lxdialog
	PKG_CONFIG_PATH="$(HOST_PKG_CONFIG_PATH)" $(MAKE) CC="$(HOSTCC_NOCCACHE)" HOSTCC="$(HOSTCC_NOCCACHE)" \
	    obj=$(@D) -C $(CONFIG) -f Makefile.br $(@F)

DEFCONFIG = $(call qstrip,$(BR2_DEFCONFIG))

# We don't want to fully expand BR2_DEFCONFIG here, so Kconfig will
# recognize that if it's still at its default $(CONFIG_DIR)/defconfig
COMMON_CONFIG_ENV = \
	BR2_DEFCONFIG='$(call qstrip,$(value BR2_DEFCONFIG))' \
	KCONFIG_AUTOCONFIG=$(BUILD_DIR)/buildroot-config/auto.conf \
	KCONFIG_AUTOHEADER=$(BUILD_DIR)/buildroot-config/autoconf.h \
	KCONFIG_TRISTATE=$(BUILD_DIR)/buildroot-config/tristate.config \
	BR2_CONFIG=$(BR2_CONFIG) \
	BR2_EXTERNAL=$(BR2_EXTERNAL) \
	HOST_GCC_VERSION="$(HOSTCC_VERSION)" \
	SKIP_LEGACY=

xconfig: $(BUILD_DIR)/buildroot-config/qconf outputmakefile
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

gconfig: $(BUILD_DIR)/buildroot-config/gconf outputmakefile
	@$(COMMON_CONFIG_ENV) srctree=$(TOPDIR) $< $(CONFIG_CONFIG_IN)

menuconfig: $(BUILD_DIR)/buildroot-config/mconf outputmakefile
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

nconfig: $(BUILD_DIR)/buildroot-config/nconf outputmakefile
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

config: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) $< $(CONFIG_CONFIG_IN)

# For the config targets that automatically select options, we pass
# SKIP_LEGACY=y to disable the legacy options. However, in that case
# no values are set for the legacy options so a subsequent oldconfig
# will query them. Therefore, run an additional olddefconfig.

oldconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) $< --oldconfig $(CONFIG_CONFIG_IN)

randconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y $< --randconfig $(CONFIG_CONFIG_IN)
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

allyesconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y $< --allyesconfig $(CONFIG_CONFIG_IN)
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

allnoconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y $< --allnoconfig $(CONFIG_CONFIG_IN)
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

randpackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --randconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

allyespackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allyesconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

allnopackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@grep -v BR2_PACKAGE_ $(BR2_CONFIG) > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) SKIP_LEGACY=y \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allnoconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN) >/dev/null

silentoldconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	$(COMMON_CONFIG_ENV) $< --silentoldconfig $(CONFIG_CONFIG_IN)

olddefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	$(COMMON_CONFIG_ENV) $< --olddefconfig $(CONFIG_CONFIG_IN)

defconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) $< --defconfig$(if $(DEFCONFIG),=$(DEFCONFIG)) $(CONFIG_CONFIG_IN)

# Override the BR2_DEFCONFIG from COMMON_CONFIG_ENV with the new defconfig
%_defconfig: $(BUILD_DIR)/buildroot-config/conf $(TOPDIR)/configs/%_defconfig outputmakefile
	@$(COMMON_CONFIG_ENV) BR2_DEFCONFIG=$(TOPDIR)/configs/$@ \
		$< --defconfig=$(TOPDIR)/configs/$@ $(CONFIG_CONFIG_IN)

%_defconfig: $(BUILD_DIR)/buildroot-config/conf $(BR2_EXTERNAL)/configs/%_defconfig outputmakefile
	@$(COMMON_CONFIG_ENV) BR2_DEFCONFIG=$(BR2_EXTERNAL)/configs/$@ \
		$< --defconfig=$(BR2_EXTERNAL)/configs/$@ $(CONFIG_CONFIG_IN)

savedefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@$(COMMON_CONFIG_ENV) $< \
		--savedefconfig=$(if $(DEFCONFIG),$(DEFCONFIG),$(CONFIG_DIR)/defconfig) \
		$(CONFIG_CONFIG_IN)
	@$(SED) '/BR2_DEFCONFIG=/d' $(if $(DEFCONFIG),$(DEFCONFIG),$(CONFIG_DIR)/defconfig)

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

# printvars prints all the variables currently defined in our
# Makefiles. Alternatively, if a non-empty VARS variable is passed,
# only the variables matching the make pattern passed in VARS are
# displayed.
printvars:
	@$(foreach V, \
		$(sort $(if $(VARS),$(filter $(VARS),$(.VARIABLES)),$(.VARIABLES))), \
		$(if $(filter-out environment% default automatic, \
				$(origin $V)), \
		$(info $V=$($V) ($(value $V)))))

clean:
	rm -rf $(TARGET_DIR) $(BINARIES_DIR) $(HOST_DIR) \
		$(BUILD_DIR) $(BASE_DIR)/staging \
		$(LEGAL_INFO_DIR) $(GRAPHS_DIR)

distclean: clean
ifeq ($(DL_DIR),$(TOPDIR)/dl)
	rm -rf $(DL_DIR)
endif
ifeq ($(O),output)
	rm -rf $(O)
endif
	rm -rf $(BR2_CONFIG) $(CONFIG_DIR)/.config.old $(CONFIG_DIR)/..config.tmp \
		$(CONFIG_DIR)/.auto.deps $(BR2_EXTERNAL_FILE)

help:
	@echo 'Cleaning:'
	@echo '  clean                  - delete all files created by build'
	@echo '  distclean              - delete all non-source files (including .config)'
	@echo
	@echo 'Build:'
	@echo '  all                    - make world'
	@echo '  toolchain              - build toolchain'
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
	@echo '  savedefconfig          - Save current config to BR2_DEFCONFIG (minimal config)'
	@echo '  allyesconfig           - New config where all options are accepted with yes'
	@echo '  allnoconfig            - New config where all options are answered with no'
	@echo '  randpackageconfig      - New config with random answer to package options'
	@echo '  allyespackageconfig    - New config where pkg options are accepted with yes'
	@echo '  allnopackageconfig     - New config where package options are answered with no'
	@echo
	@echo 'Package-specific:'
	@echo '  <pkg>                  - Build and install <pkg> and all its dependencies'
	@echo '  <pkg>-source           - Only download the source files for <pkg>'
	@echo '  <pkg>-extract          - Extract <pkg> sources'
	@echo '  <pkg>-patch            - Apply patches to <pkg>'
	@echo '  <pkg>-depends          - Build <pkg>'\''s dependencies'
	@echo '  <pkg>-configure        - Build <pkg> up to the configure step'
	@echo '  <pkg>-build            - Build <pkg> up to the build step'
	@echo '  <pkg>-graph-depends    - Generate a graph of <pkg>'\''s dependencies'
	@echo '  <pkg>-dirclean         - Remove <pkg> build directory'
	@echo '  <pkg>-reconfigure      - Restart the build from the configure step'
	@echo '  <pkg>-rebuild          - Restart the build from the build step'
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
	@echo '  busybox-menuconfig     - Run BusyBox menuconfig'
endif
ifeq ($(BR2_LINUX_KERNEL),y)
	@echo '  linux-menuconfig       - Run Linux kernel menuconfig'
	@echo '  linux-savedefconfig    - Run Linux kernel savedefconfig'
	@echo '  linux-update-defconfig - Save the Linux configuration to the path specified'
	@echo '                             by BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE'
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
	@echo '  graph-size             - generate stats of the filesystem size'
	@echo '  list-defconfigs        - list all defconfigs (pre-configured minimal systems)'
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
	@echo 'For further details, see README, generate the Buildroot manual, or consult'
	@echo 'it on-line at http://buildroot.org/docs.html'
	@echo

list-defconfigs:
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

release: OUT = buildroot-$(BR2_VERSION)

# Create release tarballs. We need to fiddle a bit to add the generated
# documentation to the git output
release:
	git archive --format=tar --prefix=$(OUT)/ HEAD > $(OUT).tar
	$(MAKE) O=$(OUT) manual-html manual-text manual-pdf
	$(MAKE) O=$(OUT) manual-clean
	tar rf $(OUT).tar $(OUT)
	gzip -9 -c < $(OUT).tar > $(OUT).tar.gz
	bzip2 -9 -c < $(OUT).tar > $(OUT).tar.bz2
	rm -rf $(OUT) $(OUT).tar

print-version:
	@echo $(BR2_VERSION_FULL)

include docs/manual/manual.mk
-include $(BR2_EXTERNAL)/docs/*/*.mk

.PHONY: $(noconfig_targets)

endif #umask
