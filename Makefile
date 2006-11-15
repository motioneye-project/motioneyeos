# Makefile for buildroot2
#
# Copyright (C) 1999-2005 by Erik Andersen <andersen@codepoet.org>
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
TOPDIR=./
CONFIG_CONFIG_IN = Config.in
CONFIG_DEFCONFIG = .defconfig
CONFIG = package/config

noconfig_targets := menuconfig config oldconfig randconfig \
	defconfig allyesconfig allnoconfig release tags    \
	$(shell find . -name *_defconfig |sed 's/.*\///')

# Pull in the user's configuration file
ifeq ($(filter $(noconfig_targets),$(MAKECMDGOALS)),)
-include $(TOPDIR).config
endif

ifeq ($(strip $(BR2_HAVE_DOT_CONFIG)),y)

#############################################################
#
# The list of stuff to build for the target toolchain
# along with the packages to build for the target.
#
##############################################################
TARGETS:=uclibc-configured binutils gcc uclibc-target-utils
include toolchain/Makefile.in
include package/Makefile.in

#############################################################
#
# You should probably leave this stuff alone unless you know
# what you are doing.
#
#############################################################



all:   world

# In this section, we need .config
include .config.cmd

# We also need the various per-package makefiles, which also add
# each selected package to TARGETS if that package was selected
# in the .config file.
include toolchain/*/*.mk
include package/*/*.mk
include target/*/*.mk

# target stuff is last so it can override anything else
include target/Makefile.in

TARGETS_CLEAN:=$(patsubst %,%-clean,$(TARGETS))
TARGETS_SOURCE:=$(patsubst %,%-source,$(TARGETS))
TARGETS_DIRCLEAN:=$(patsubst %,%-dirclean,$(TARGETS))

world: $(DL_DIR) $(BUILD_DIR) $(STAGING_DIR) $(TARGET_DIR) $(TARGETS)

.PHONY: all world clean dirclean distclean source $(TARGETS) \
	$(TARGETS_CLEAN) $(TARGETS_DIRCLEAN) $(TARGETS_SOURCE) \
	$(DL_DIR) $(BUILD_DIR) $(TOOL_BUILD_DIR) $(STAGING_DIR)

#############################################################
#
# staging and target directories do NOT list these as
# dependencies anywhere else
#
#############################################################
$(DL_DIR):
	@mkdir -p $(DL_DIR)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(TOOL_BUILD_DIR):
	@mkdir -p $(TOOL_BUILD_DIR)

$(STAGING_DIR):
	@mkdir -p $(STAGING_DIR)/lib
	@mkdir -p $(STAGING_DIR)/include
	@mkdir -p $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)
	@ln -snf ../lib $(STAGING_DIR)/$(REAL_GNU_TARGET_NAME)/lib

$(TARGET_DIR):
	if [ -d "$(TARGET_SKELETON)" ] ; then \
		cp -fa $(TARGET_SKELETON)/* $(TARGET_DIR)/; \
	fi;
	touch $(STAGING_DIR)/.fakeroot.00000
	-find $(TARGET_DIR) -type d -name CVS | xargs rm -rf
	-find $(TARGET_DIR) -type d -name .svn | xargs rm -rf

source: $(TARGETS_SOURCE)

#############################################################
#
# Cleanup and misc junk
#
#############################################################
clean: $(TARGETS_CLEAN)
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)

dirclean: $(TARGETS_DIRCLEAN)
	rm -rf $(STAGING_DIR) $(TARGET_DIR) $(IMAGE)

distclean:
ifeq ($(DL_DIR),$(BASE_DIR)/dl)
	rm -rf $(DL_DIR)
endif
	rm -rf $(BUILD_DIR) $(LINUX_KERNEL) $(IMAGE)

sourceball:
	rm -rf $(BUILD_DIR)
	set -e; \
	cd ..; \
	rm -f buildroot.tar.bz2; \
	tar -cvf buildroot.tar buildroot; \
	bzip2 -9 buildroot.tar; \


else # ifeq ($(strip $(BR2_HAVE_DOT_CONFIG)),y)

all: menuconfig

# configuration
# ---------------------------------------------------------------------------

$(CONFIG)/conf:
	$(MAKE) -C $(CONFIG) conf
	-@if [ ! -f .config ] ; then \
		cp $(CONFIG_DEFCONFIG) .config; \
	fi
$(CONFIG)/mconf:
	$(MAKE) -C $(CONFIG) ncurses conf mconf
	-@if [ ! -f .config ] ; then \
		cp $(CONFIG_DEFCONFIG) .config; \
	fi

menuconfig: $(CONFIG)/mconf
	@$(CONFIG)/mconf $(CONFIG_CONFIG_IN)

config: $(CONFIG)/conf
	@$(CONFIG)/conf $(CONFIG_CONFIG_IN)

oldconfig: $(CONFIG)/conf
	@$(CONFIG)/conf -o $(CONFIG_CONFIG_IN)

randconfig: $(CONFIG)/conf
	@$(CONFIG)/conf -r $(CONFIG_CONFIG_IN)

allyesconfig: $(CONFIG)/conf
	#@$(CONFIG)/conf -y $(CONFIG_CONFIG_IN)
	#sed -i -e "s/^CONFIG_DEBUG.*/# CONFIG_DEBUG is not set/" .config
	@$(CONFIG)/conf -o $(CONFIG_CONFIG_IN)

allnoconfig: $(CONFIG)/conf
	@$(CONFIG)/conf -n $(CONFIG_CONFIG_IN)

defconfig: $(CONFIG)/conf
	@$(CONFIG)/conf -d $(CONFIG_CONFIG_IN)

%_defconfig: $(CONFIG)/conf
	cp $(shell find . -name $@) .config
	@$(CONFIG)/conf -o $(CONFIG_CONFIG_IN)

#############################################################
#
# Cleanup and misc junk
#
#############################################################
clean:
	rm -f .config .config.old .config.cmd .tmpconfig.h
	- $(MAKE) -C $(CONFIG) clean

distclean: clean
	rm -rf sources/*

endif # ifeq ($(strip $(BR2_HAVE_DOT_CONFIG)),y)

.PHONY: dummy subdirs release distclean clean config oldconfig \
	menuconfig tags check test depend defconfig


