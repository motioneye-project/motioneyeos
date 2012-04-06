# Makefile for buildroot2
#
# Copyright (C) 1999-2005 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2006-2012 by the Buildroot developers <buildroot@uclibc.org>
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
export BR2_VERSION:=2012.05-git

# Check for minimal make version (note: this check will break at make 10.x)
MIN_MAKE_VERSION=3.81
ifneq ($(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))),$(MIN_MAKE_VERSION))
$(error You have make '$(MAKE_VERSION)' installed. GNU make >= $(MIN_MAKE_VERSION) is required)
endif

# This top-level Makefile can *not* be executed in parallel
.NOTPARALLEL:

# absolute path
TOPDIR:=$(shell pwd)
CONFIG_CONFIG_IN=Config.in
CONFIG=support/kconfig
DATE:=$(shell date +%Y%m%d)

# Compute the full local version string so packages can use it as-is
# Need to export it, so it can be got from environment in children (eg. mconf)
export BR2_VERSION_FULL:=$(BR2_VERSION)$(shell $(TOPDIR)/support/scripts/setlocalversion)

noconfig_targets:=menuconfig nconfig gconfig xconfig config oldconfig randconfig \
	defconfig %_defconfig savedefconfig allyesconfig allnoconfig silentoldconfig release \
	randpackageconfig allyespackageconfig allnopackageconfig \
	source-check print-version

# Strip quotes and then whitespaces
qstrip=$(strip $(subst ",,$(1)))
#"))

# Variables for use in Make constructs
comma:=,
empty:=
space:=$(empty) $(empty)

ifneq ("$(origin O)", "command line")
O:=output
CONFIG_DIR:=$(TOPDIR)
NEED_WRAPPER=
else
# other packages might also support Linux-style out of tree builds
# with the O=<dir> syntax (E.G. Busybox does). As make automatically
# forwards command line variable definitions those packages get very
# confused. Fix this by telling make to not do so
MAKEOVERRIDES =
# strangely enough O is still passed to submakes with MAKEOVERRIDES
# (with make 3.81 atleast), the only thing that changes is the output
# of the origin function (command line -> environment).
# Unfortunately some packages don't look at origin (E.G. uClibc 0.9.31+)
# To really make O go away, we have to override it.
override O:=$(O)
CONFIG_DIR:=$(O)
# we need to pass O= everywhere we call back into the toplevel makefile
EXTRAMAKEARGS = O=$(O)
NEED_WRAPPER=y
endif

# Pull in the user's configuration file
ifeq ($(filter $(noconfig_targets),$(MAKECMDGOALS)),)
-include $(CONFIG_DIR)/.config
endif

# Override BR2_DL_DIR if shell variable defined
ifneq ($(BUILDROOT_DL_DIR),)
BR2_DL_DIR:=$(BUILDROOT_DL_DIR)
endif

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
ifdef V
  ifeq ("$(origin V)", "command line")
    KBUILD_VERBOSE=$(V)
  endif
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE=0
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet=
  Q=
ifndef VERBOSE
  VERBOSE=1
endif
else
  quiet=quiet_
  Q=@
endif

# we want bash as shell
SHELL:=$(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	else if [ -x /bin/bash ]; then echo /bin/bash; \
	else echo sh; fi; fi)

# kconfig uses CONFIG_SHELL
CONFIG_SHELL:=$(SHELL)

export SHELL CONFIG_SHELL quiet Q KBUILD_VERBOSE VERBOSE

ifndef HOSTAR
HOSTAR:=ar
endif
ifndef HOSTAS
HOSTAS:=as
endif
ifndef HOSTCC
HOSTCC:=gcc
HOSTCC:=$(shell which $(HOSTCC) || type -p $(HOSTCC) || echo gcc)
endif
HOSTCC_NOCCACHE:=$(HOSTCC)
ifndef HOSTCXX
HOSTCXX:=g++
HOSTCXX:=$(shell which $(HOSTCXX) || type -p $(HOSTCXX) || echo g++)
endif
HOSTCXX_NOCCACHE:=$(HOSTCXX)
ifndef HOSTFC
HOSTFC:=gfortran
endif
ifndef HOSTCPP
HOSTCPP:=cpp
endif
ifndef HOSTLD
HOSTLD:=ld
endif
ifndef HOSTLN
HOSTLN:=ln
endif
ifndef HOSTNM
HOSTNM:=nm
endif
HOSTAR:=$(shell which $(HOSTAR) || type -p $(HOSTAR) || echo ar)
HOSTAS:=$(shell which $(HOSTAS) || type -p $(HOSTAS) || echo as)
HOSTFC:=$(shell which $(HOSTLD) || type -p $(HOSTLD) || echo || which g77 || type -p g77 || echo gfortran)
HOSTCPP:=$(shell which $(HOSTCPP) || type -p $(HOSTCPP) || echo cpp)
HOSTLD:=$(shell which $(HOSTLD) || type -p $(HOSTLD) || echo ld)
HOSTLN:=$(shell which $(HOSTLN) || type -p $(HOSTLN) || echo ln)
HOSTNM:=$(shell which $(HOSTNM) || type -p $(HOSTNM) || echo nm)

export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTFC HOSTLD
export HOSTCC_NOCCACHE HOSTCXX_NOCCACHE

# bash prints the name of the directory on 'cd <dir>' if CDPATH is
# set, so unset it here to not cause problems. Notice that the export
# line doesn't affect the environment of $(shell ..) calls, so
# explictly throw away any output from 'cd' here.
export CDPATH:=
BASE_DIR := $(shell mkdir -p $(O) && cd $(O) >/dev/null && pwd)
$(if $(BASE_DIR),, $(error output directory "$(O)" does not exist))

BUILD_DIR:=$(BASE_DIR)/build


ifeq ($(BR2_HAVE_DOT_CONFIG),y)

# cc-option
# Usage: cflags-y+=$(call cc-option, -march=winchip-c6, -march=i586)
# sets -march=winchip-c6 if supported else falls back to -march=i586
# without checking the latter.
cc-option=$(shell if $(TARGET_CC) $(TARGET_CFLAGS) $(1) -S -o /dev/null -xc /dev/null \
	> /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)

#############################################################
#
# Hide troublesome environment variables from sub processes
#
#############################################################
unexport CROSS_COMPILE
unexport ARCH
unexport CC
unexport CXX
unexport CPP
unexport CFLAGS
unexport CXXFLAGS
unexport GREP_OPTIONS
unexport CONFIG_SITE

GNU_HOST_NAME:=$(shell support/gnuconfig/config.guess)

#############################################################
#
# Setup the proper filename extensions for the host
#
##############################################################
ifneq ($(findstring linux,$(GNU_HOST_NAME)),)
HOST_EXEEXT:=
HOST_LIBEXT:=.a
HOST_SHREXT:=.so
endif
ifneq ($(findstring apple,$(GNU_HOST_NAME)),)
HOST_EXEEXT:=
HOST_LIBEXT:=.a
HOST_SHREXT:=.dylib
endif
ifneq ($(findstring cygwin,$(GNU_HOST_NAME)),)
HOST_EXEEXT:=.exe
HOST_LIBEXT:=.lib
HOST_SHREXT:=.dll
HOST_LOADLIBES=-lcurses -lintl
export HOST_LOADLIBES
endif
ifneq ($(findstring mingw,$(GNU_HOST_NAME)),)
HOST_EXEEXT:=.exe
HOST_LIBEXT:=.lib
HOST_SHREXT:=.dll
endif

##############################################################
#
# The list of stuff to build for the target toolchain
# along with the packages to build for the target.
#
##############################################################

ifeq ($(BR2_CCACHE),y)
BASE_TARGETS += host-ccache
endif

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
BASE_TARGETS += uclibc-configured host-binutils cross_compiler uclibc-target-utils kernel-headers
else
BASE_TARGETS += uclibc
endif
TARGETS:=

# silent mode requested?
QUIET:=$(if $(findstring s,$(MAKEFLAGS)),-q)

# Strip off the annoying quoting
ARCH:=$(call qstrip,$(BR2_ARCH))
ifeq ($(ARCH),xtensa)
ARCH:=$(ARCH)_$(call qstrip,$(BR2_xtensa_core_name))
endif

KERNEL_ARCH:=$(shell echo "$(ARCH)" | sed -e "s/-.*//" \
	-e s/i.86/i386/ -e s/sun4u/sparc64/ \
	-e s/arm.*/arm/ -e s/sa110/arm/ \
	-e s/bfin/blackfin/ \
	-e s/parisc64/parisc/ \
	-e s/powerpc64/powerpc/ \
	-e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
	-e s/sh.*/sh/)

ZCAT:=$(call qstrip,$(BR2_ZCAT))
BZCAT:=$(call qstrip,$(BR2_BZCAT))
XZCAT:=$(call qstrip,$(BR2_XZCAT))
TAR_OPTIONS=$(call qstrip,$(BR2_TAR_OPTIONS)) -xf

GNU_TARGET_SUFFIX:=-$(call qstrip,$(BR2_GNU_TARGET_SUFFIX))

# packages compiled for the host go here
HOST_DIR:=$(call qstrip,$(BR2_HOST_DIR))

# stamp (dependency) files go here
STAMP_DIR:=$(BASE_DIR)/stamps

BINARIES_DIR:=$(BASE_DIR)/images
TARGET_DIR:=$(BASE_DIR)/target
TOOLCHAIN_DIR=$(BASE_DIR)/toolchain
TARGET_SKELETON=$(TOPDIR)/fs/skeleton

ifeq ($(BR2_CCACHE),y)
CCACHE:=$(HOST_DIR)/usr/bin/ccache
CCACHE_CACHE_DIR=$(HOME)/.buildroot-ccache
HOSTCC  := $(CCACHE) $(HOSTCC)
HOSTCXX := $(CCACHE) $(HOSTCXX)
endif

include toolchain/Makefile.in
include package/Makefile.in

#############################################################
#
# You should probably leave this stuff alone unless you know
# what you are doing.
#
#############################################################

all: world

include support/dependencies/dependencies.mk

# We also need the various per-package makefiles, which also add
# each selected package to TARGETS if that package was selected
# in the .config file.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)
include toolchain/toolchain-buildroot.mk
else ifeq ($(BR2_TOOLCHAIN_EXTERNAL),y)
include toolchain/toolchain-external.mk
else ifeq ($(BR2_TOOLCHAIN_CTNG),y)
include toolchain/toolchain-crosstool-ng.mk
endif

# Include the package override file if one has been provided in the
# configuration.
PACKAGE_OVERRIDE_FILE=$(call qstrip,$(BR2_PACKAGE_OVERRIDE_FILE))
ifneq ($(PACKAGE_OVERRIDE_FILE),)
-include $(PACKAGE_OVERRIDE_FILE)
endif

include package/*/*.mk

include boot/common.mk
include target/Makefile.in
include linux/linux.mk

TARGETS+=target-finalize

ifeq ($(BR2_ENABLE_LOCALE_PURGE),y)
TARGETS+=target-purgelocales
endif

include fs/common.mk

TARGETS+=erase-fakeroots

TARGETS_CLEAN:=$(patsubst %,%-clean,$(TARGETS))
TARGETS_SOURCE:=$(patsubst %,%-source,$(TARGETS) $(BASE_TARGETS))
TARGETS_DIRCLEAN:=$(patsubst %,%-dirclean,$(TARGETS))
TARGETS_ALL:=$(patsubst %,__real_tgt_%,$(TARGETS))

# host-* dependencies have to be handled specially, as those aren't
# visible in Kconfig and hence not added to a variable like TARGETS.
# instead, find all the host-* targets listed in each <PKG>_DEPENDENCIES
# variable for each enabled target.
# Notice: this only works for newstyle gentargets/autotargets packages
TARGETS_HOST_DEPS = $(sort $(filter host-%,$(foreach dep,\
		$(addsuffix _DEPENDENCIES,$(call UPPERCASE,$(TARGETS))),\
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

# all targets depend on the crosscompiler and it's prerequisites
$(TARGETS_ALL): __real_tgt_%: $(BASE_TARGETS) %

dirs: $(DL_DIR) $(TOOLCHAIN_DIR) $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) \
	$(HOST_DIR) $(BINARIES_DIR) $(STAMP_DIR)

$(BASE_TARGETS): dirs $(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake

$(BUILD_DIR)/buildroot-config/auto.conf: $(CONFIG_DIR)/.config
	$(MAKE) $(EXTRAMAKEARGS) HOSTCC="$(HOSTCC_NOCCACHE)" HOSTCXX="$(HOSTCXX_NOCCACHE)" silentoldconfig

prepare: $(BUILD_DIR)/buildroot-config/auto.conf

world: prepare dirs dependencies $(BASE_TARGETS) $(TARGETS_ALL)

$(HOST_DIR)/usr/share/buildroot/toolchainfile.cmake:
	mkdir -p $(@D)
	@echo -en "\
	set(CMAKE_SYSTEM_NAME Linux)\n\
	set(CMAKE_C_COMPILER $(TARGET_CC_NOCCACHE))\n\
	set(CMAKE_CXX_COMPILER $(TARGET_CXX_NOCCACHE))\n\
	set(CMAKE_C_FLAGS \"\$${CMAKE_C_FLAGS} $(TARGET_CFLAGS)\" CACHE STRING \"Buildroot CFLAGS\" FORCE)\n\
	set(CMAKE_CXX_FLAGS \"\$${CMAKE_CXX_FLAGS} $(TARGET_CXXFLAGS)\" CACHE STRING \"Buildroot CXXFLAGS\" FORCE)\n\
	set(CMAKE_INSTALL_SO_NO_EXE 0)\n\
	set(CMAKE_PROGRAM_PATH \"$(HOST_DIR)/usr/bin\")\n\
	set(CMAKE_FIND_ROOT_PATH \"$(STAGING_DIR)\")\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)\n\
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)\n\
	set(ENV{PKG_CONFIG_SYSROOT_DIR} \"$(STAGING_DIR)\")\n\
	" > $@

.PHONY: all world dirs clean distclean source outputmakefile \
	$(BASE_TARGETS) $(TARGETS) $(TARGETS_ALL) \
	$(TARGETS_CLEAN) $(TARGETS_DIRCLEAN) $(TARGETS_SOURCE) \
	$(DL_DIR) $(TOOLCHAIN_DIR) $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) \
	$(HOST_DIR) $(BINARIES_DIR) $(STAMP_DIR)

#############################################################
#
# staging and target directories do NOT list these as
# dependencies anywhere else
#
#############################################################
$(DL_DIR) $(TOOLCHAIN_DIR) $(BUILD_DIR) $(HOST_DIR) $(BINARIES_DIR) $(STAMP_DIR):
	@mkdir -p $@

$(STAGING_DIR):
	@mkdir -p $(STAGING_DIR)/bin
	@mkdir -p $(STAGING_DIR)/lib
	@mkdir -p $(STAGING_DIR)/usr/lib
	@mkdir -p $(STAGING_DIR)/usr/include
	@mkdir -p $(STAGING_DIR)/usr/bin
	@ln -snf $(STAGING_DIR) $(BASE_DIR)/staging

ifeq ($(BR2_ROOTFS_SKELETON_CUSTOM),y)
TARGET_SKELETON=$(BR2_ROOTFS_SKELETON_CUSTOM_PATH)
endif

$(BUILD_DIR)/.root:
	mkdir -p $(TARGET_DIR)
	if ! [ -d "$(TARGET_DIR)/bin" ]; then \
		if [ -d "$(TARGET_SKELETON)" ]; then \
			cp -fa $(TARGET_SKELETON)/* $(TARGET_DIR)/; \
		fi; \
		touch $(STAGING_DIR)/.fakeroot.00000; \
	fi
	-find $(TARGET_DIR) -type d -name CVS -print0 -o -name .svn -print0 | xargs -0 rm -rf
	-find $(TARGET_DIR) -type f \( -name .empty -o -name '*~' \) -print0 | xargs -0 rm -rf
	touch $@

$(TARGET_DIR): $(BUILD_DIR)/.root

erase-fakeroots:
	rm -f $(BUILD_DIR)/.fakeroot*

target-finalize:
ifeq ($(BR2_HAVE_DEVFILES),y)
	( support/scripts/copy.sh $(STAGING_DIR) $(TARGET_DIR) )
else
	rm -rf $(TARGET_DIR)/usr/include $(TARGET_DIR)/usr/lib/pkgconfig $(TARGET_DIR)/usr/share/aclocal
	find $(TARGET_DIR)/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/usr/lib \( -name '*.a' -o -name '*.la' \) -print0 | xargs -0 rm -f
endif
ifneq ($(BR2_PACKAGE_GDB),y)
	rm -rf $(TARGET_DIR)/usr/share/gdb
endif
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/man
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/share/info
	rm -rf $(TARGET_DIR)/usr/doc $(TARGET_DIR)/usr/share/doc
	rm -rf $(TARGET_DIR)/usr/share/gtk-doc
	-rmdir $(TARGET_DIR)/usr/share 2>/dev/null
endif
ifeq ($(BR2_PACKAGE_PYTHON_PY_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.pyc' -print0 | xargs -0 rm -f
endif
ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY),y)
	find $(TARGET_DIR)/usr/lib/ -name '*.py' -print0 | xargs -0 rm -f
endif
	find $(TARGET_DIR) -type f -perm +111 '!' -name 'libthread_db*.so*' | \
		xargs $(STRIPCMD) 2>/dev/null || true
	find $(TARGET_DIR)/lib/modules -type f -name '*.ko' | \
		xargs -r $(KSTRIPCMD) || true

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

ifneq ($(BR2_ROOTFS_POST_BUILD_SCRIPT),"")
	@$(call MESSAGE,"Executing post-build script")
	$(BR2_ROOTFS_POST_BUILD_SCRIPT) $(TARGET_DIR)
endif

ifeq ($(BR2_ENABLE_LOCALE_PURGE),y)
LOCALE_WHITELIST=$(BUILD_DIR)/locales.nopurge
LOCALE_NOPURGE=$(call qstrip,$(BR2_ENABLE_LOCALE_WHITELIST))

target-purgelocales:
	rm -f $(LOCALE_WHITELIST)
	for i in $(LOCALE_NOPURGE); do echo $$i >> $(LOCALE_WHITELIST); done

	for dir in $(wildcard $(addprefix $(TARGET_DIR),/usr/share/locale /usr/share/X11/locale /usr/man /usr/share/man)); \
	do \
		for lang in $$(cd $$dir; ls .|grep -v man); \
		do \
			grep -qx $$lang $(LOCALE_WHITELIST) || rm -rf $$dir/$$lang; \
		done; \
	done
endif

source: dirs $(TARGETS_SOURCE) $(HOST_SOURCE)

external-deps:
	@$(MAKE) -Bs DL_MODE=SHOW_EXTERNAL_DEPS $(EXTRAMAKEARGS) source | sort -u

show-targets:
	@echo $(TARGETS)

else # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

all: menuconfig

# configuration
# ---------------------------------------------------------------------------

HOSTCFLAGS=$(CFLAGS_FOR_BUILD)
export HOSTCFLAGS

$(BUILD_DIR)/buildroot-config/%onf:
	mkdir -p $(@D)/lxdialog
	$(MAKE) CC="$(HOSTCC_NOCCACHE)" HOSTCC="$(HOSTCC_NOCCACHE)" obj=$(@D) -C $(CONFIG) -f Makefile.br $(@F)

COMMON_CONFIG_ENV = \
	KCONFIG_AUTOCONFIG=$(BUILD_DIR)/buildroot-config/auto.conf \
	KCONFIG_AUTOHEADER=$(BUILD_DIR)/buildroot-config/autoconf.h \
	KCONFIG_TRISTATE=$(BUILD_DIR)/buildroot-config/tristate.config \
	BUILDROOT_CONFIG=$(CONFIG_DIR)/.config

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
	@grep -v BR2_PACKAGE_ $(CONFIG_DIR)/.config > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --randconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

allyespackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@grep -v BR2_PACKAGE_ $(CONFIG_DIR)/.config > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allyesconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

allnopackageconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@grep -v BR2_PACKAGE_ $(CONFIG_DIR)/.config > $(CONFIG_DIR)/.config.nopkg
	@$(COMMON_CONFIG_ENV) \
		KCONFIG_ALLCONFIG=$(CONFIG_DIR)/.config.nopkg \
		$< --allnoconfig $(CONFIG_CONFIG_IN)
	@rm -f $(CONFIG_DIR)/.config.nopkg

silentoldconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	$(COMMON_CONFIG_ENV) $< --silentoldconfig $(CONFIG_CONFIG_IN)

defconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --defconfig $(CONFIG_CONFIG_IN)

%_defconfig: $(BUILD_DIR)/buildroot-config/conf $(TOPDIR)/configs/%_defconfig outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --defconfig=$(TOPDIR)/configs/$@ $(CONFIG_CONFIG_IN)

savedefconfig: $(BUILD_DIR)/buildroot-config/conf outputmakefile
	@mkdir -p $(BUILD_DIR)/buildroot-config
	@$(COMMON_CONFIG_ENV) $< --savedefconfig=$(CONFIG_DIR)/defconfig $(CONFIG_CONFIG_IN)

# check if download URLs are outdated
source-check: allyesconfig
	$(MAKE) DL_MODE=SOURCE_CHECK $(EXTRAMAKEARGS) source

endif # ifeq ($(BR2_HAVE_DOT_CONFIG),y)

#############################################################
#
# Cleanup and misc junk
#
#############################################################

# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.
outputmakefile:
ifeq ($(NEED_WRAPPER),y)
	$(Q)$(TOPDIR)/support/scripts/mkmakefile $(TOPDIR) $(O)
endif

clean:
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(BINARIES_DIR) $(HOST_DIR) \
		$(STAMP_DIR) $(BUILD_DIR) $(TOOLCHAIN_DIR) $(BASE_DIR)/staging

distclean: clean
ifeq ($(DL_DIR),$(TOPDIR)/dl)
	rm -rf $(DL_DIR)
endif
ifeq ($(O),output)
	rm -rf $(O)
endif
	rm -rf $(CONFIG_DIR)/.config $(CONFIG_DIR)/.config.old $(CONFIG_DIR)/.auto.deps

cross: $(BASE_TARGETS)

help:
	@echo 'Cleaning:'
	@echo '  clean                  - delete all files created by build'
	@echo '  distclean              - delete all non-source files (including .config)'
	@echo
	@echo 'Build:'
	@echo '  all                    - make world'
	@echo '  <package>-rebuild      - force recompile <package>'
	@echo '  <package>-reconfigure  - force reconfigure <package>'
	@echo
	@echo 'Configuration:'
	@echo '  menuconfig             - interactive curses-based configurator'
	@echo '  nconfig                - interactive ncurses-based configurator'
	@echo '  xconfig                - interactive Qt-based configurator'
	@echo '  gconfig                - interactive GTK-based configurator'
	@echo '  oldconfig              - resolve any unresolved symbols in .config'
	@echo '  randconfig             - New config with random answer to all options'
	@echo '  defconfig              - New config with default answer to all options'
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
ifeq ($(BR2_TOOLCHAIN_CTNG),y)
	@echo '  ctng-menuconfig        - Run crosstool-NG menuconfig'
endif
ifeq ($(BR2_TARGET_BAREBOX),y)
	@echo '  barebox-menuconfig     - Run barebox menuconfig'
	@echo '  barebox-savedefconfig  - Run barebox savedefconfig'
endif
	@echo
	@echo 'Documentation:'
	@echo '  manual                 - build manual in HTML, split HTML, PDF and txt'
	@echo '  manual-html            - build manual in HTML'
	@echo '  manual-split-html      - build manual in split HTML'
	@echo '  manual-pdf             - build manual in PDF'
	@echo '  manual-txt             - build manual in txt'
	@echo '  manual-epub            - build manual in ePub'
	@echo
	@echo 'Miscellaneous:'
	@echo '  source                 - download all sources needed for offline-build'
	@echo '  source-check           - check all packages for valid download URLs'
	@echo '  external-deps          - list external packages used'
	@echo
	@echo '  make V=0|1             - 0 => quiet build (default), 1 => verbose build'
	@echo '  make O=dir             - Locate all output files in "dir", including .config'
	@echo
	@$(foreach b, $(sort $(notdir $(wildcard $(TOPDIR)/configs/*_defconfig))), \
	  printf "  %-35s - Build for %s\\n" $(b) $(b:_defconfig=);)
	@echo
	@echo 'See docs/README, or generate the Buildroot manual for further details'
	@echo

release: OUT=buildroot-$(BR2_VERSION)

# Create release tarballs. We need to fiddle a bit to add the generated
# documentation to the git output
release:
	git archive --format=tar --prefix=$(OUT)/ master > $(OUT).tar
	$(MAKE) O=$(OUT) manual-html manual-txt manual-pdf
	tar rf $(OUT).tar $(OUT)
	gzip -9 -c < $(OUT).tar > $(OUT).tar.gz
	bzip2 -9 -c < $(OUT).tar > $(OUT).tar.bz2
	rm -rf $(OUT) $(OUT).tar

print-version:
	@echo $(BR2_VERSION_FULL)

################################################################################
# GENDOC -- generates the make targets needed to build a specific type of
#           asciidoc documentation.
#
#  argument 1 is the name of the document and must be a subdirectory of docs/;
#             the top-level asciidoc file must have the same name
#  argument 2 is the type of document to generate (-f argument of a2x)
#  argument 3 is the document type as used in the make target
#  argument 4 is the output file extension for the document type
#  argument 5 is the human text for the document type
#  argument 6 (optional) are extra arguments for a2x
#
# The variable <DOCUMENT_NAME>_SOURCES defines the dependencies.
################################################################################
define GENDOC_INNER
$(1): $(1)-$(3)
.PHONY: $(1)-$(3)
$(1)-$(3): $$(O)/docs/$(1)/$(1).$(4)

$$(O)/docs/$(1)/$(1).$(4): docs/$(1)/$(1).txt $$($(call UPPERCASE,$(1))_SOURCES)
	@echo "Generating $(5) $(1)..."
	$(Q)mkdir -p $$(@D)
	$(Q)a2x $(6) -f $(2) -d book -L -r $(TOPDIR)/docs/images \
	  -D $$(@D) $$<
endef

################################################################################
# GENDOC -- generates the make targets needed to build asciidoc documentation.
#
#  argument 1 is the name of the document and must be a subdirectory of docs/;
#             the top-level asciidoc file must have the same name
#
# The variable <DOCUMENT_NAME>_SOURCES defines the dependencies.
################################################################################
define GENDOC
$(call GENDOC_INNER,$(1),xhtml,html,html,HTML)
$(call GENDOC_INNER,$(1),chunked,split-html,chunked,Split HTML)
$(call GENDOC_INNER,$(1),pdf,pdf,pdf,PDF,--dblatex-opts "-P latex.output.revhistory=0")
$(call GENDOC_INNER,$(1),text,txt,text,Text)
$(call GENDOC_INNER,$(1),epub,epub,epub,EPUB)
clean: clean-$(1)
clean-$(1):
	$(Q)$(RM) -rf $(O)/docs/$(1)
.PHONY: $(1) clean-$(1)
endef

MANUAL_SOURCES = $(wildcard docs/manual/*.txt) $(wildcard docs/images/*)
$(eval $(call GENDOC,manual))

.PHONY: $(noconfig_targets)

