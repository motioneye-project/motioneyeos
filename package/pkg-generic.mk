################################################################################
# Generic package infrastructure
#
# This file implements an infrastructure that eases development of
# package .mk files. It should be used for packages that do not rely
# on a well-known build system for which Buildroot has a dedicated
# infrastructure (so far, Buildroot has special support for
# autotools-based and CMake-based packages).
#
# See the Buildroot documentation for details on the usage of this
# infrastructure
#
# In terms of implementation, this generic infrastructure requires the
# .mk file to specify:
#
#   1. Metadata informations about the package: name, version,
#      download URL, etc.
#
#   2. Description of the commands to be executed to configure, build
#      and install the package
################################################################################

################################################################################
# Helper functions to catch start/end of each step
################################################################################

# Those two functions are called by each step below.
# They are responsible for calling all hooks defined in
# $(GLOBAL_INSTRUMENTATION_HOOKS) and pass each of them
# three arguments:
#   $1: either 'start' or 'end'
#   $2: the name of the step
#   $3: the name of the package

# Start step
# $1: step name
define step_start
	$(foreach hook,$(GLOBAL_INSTRUMENTATION_HOOKS),$(call $(hook),start,$(1),$($(PKG)_NAME))$(sep))
endef

# End step
# $1: step name
define step_end
	$(foreach hook,$(GLOBAL_INSTRUMENTATION_HOOKS),$(call $(hook),end,$(1),$($(PKG)_NAME))$(sep))
endef

#######################################
# Actual steps hooks

# Time steps
define step_time
	printf "%s:%-5.5s:%-20.20s: %s\n"           \
	       "$$(date +%s)" "$(1)" "$(2)" "$(3)"  \
	       >>"$(BUILD_DIR)/build-time.log"
endef
GLOBAL_INSTRUMENTATION_HOOKS += step_time

# User-supplied script
define step_user
	@$(foreach user_hook, $(BR2_INSTRUMENTATION_SCRIPTS), \
		$(EXTRA_ENV) $(user_hook) "$(1)" "$(2)" "$(3)"$(sep))
endef
ifneq ($(BR2_INSTRUMENTATION_SCRIPTS),)
GLOBAL_INSTRUMENTATION_HOOKS += step_user
endif

################################################################################
# Implicit targets -- produce a stamp file for each step of a package build
################################################################################

# Retrieve the archive
$(BUILD_DIR)/%/.stamp_downloaded:
	$(foreach hook,$($(PKG)_PRE_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
ifeq ($(DL_MODE),DOWNLOAD)
# Only show the download message if it isn't already downloaded
	$(Q)if test ! -e $(DL_DIR)/$($(PKG)_SOURCE); then \
		$(call MESSAGE,"Downloading") ; \
	else \
		for p in $($(PKG)_PATCH) ; do \
			if test ! -e $(DL_DIR)/$$p ; then \
				$(call MESSAGE,"Downloading") ; \
				break ; \
			fi ; \
		done ; \
	fi
endif
	$(if $($(PKG)_SOURCE),$(call DOWNLOAD,$($(PKG)_SITE:/=)/$($(PKG)_SOURCE)))
	$(foreach p,$($(PKG)_EXTRA_DOWNLOADS),$(call DOWNLOAD,$($(PKG)_SITE:/=)/$(p))$(sep))
	$(foreach p,$($(PKG)_PATCH),\
		$(if $(findstring ://,$(p)),\
			$(call DOWNLOAD,$(p)),\
			$(call DOWNLOAD,$($(PKG)_SITE:/=)/$(p))\
		)\
	$(sep))
	$(foreach hook,$($(PKG)_POST_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
ifeq ($(DL_MODE),DOWNLOAD)
	$(Q)mkdir -p $(@D)
	$(Q)touch $@
endif

# Unpack the archive
$(BUILD_DIR)/%/.stamp_extracted:
	@$(call step_start,extract)
	@$(call MESSAGE,"Extracting")
	$(foreach hook,$($(PKG)_PRE_EXTRACT_HOOKS),$(call $(hook))$(sep))
	$(Q)mkdir -p $(@D)
	$($(PKG)_EXTRACT_CMDS)
# some packages have messed up permissions inside
	$(Q)chmod -R +rw $(@D)
	$(foreach hook,$($(PKG)_POST_EXTRACT_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,extract)

# Rsync the source directory if the <pkg>_OVERRIDE_SRCDIR feature is
# used.
$(BUILD_DIR)/%/.stamp_rsynced:
	@$(call MESSAGE,"Syncing from source dir $(SRCDIR)")
	@test -d $(SRCDIR) || (echo "ERROR: $(SRCDIR) does not exist" ; exit 1)
	$(foreach hook,$($(PKG)_PRE_RSYNC_HOOKS),$(call $(hook))$(sep))
	rsync -au $(RSYNC_VCS_EXCLUSIONS) $(SRCDIR)/ $(@D)
	$(foreach hook,$($(PKG)_POST_RSYNC_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@

# Handle the SOURCE_CHECK and SHOW_EXTERNAL_DEPS cases for rsynced
# packages
$(BUILD_DIR)/%/.stamp_rsync_sourced:
ifeq ($(DL_MODE),SOURCE_CHECK)
	test -d $(SRCDIR)
else ifeq ($(DL_MODE),SHOW_EXTERNAL_DEPS)
	echo "file://$(SRCDIR)"
else
	@true # Nothing to do to source a local package
endif

# Patch
#
# The RAWNAME variable is the lowercased package name, which allows to
# find the package directory (typically package/<pkgname>) and the
# prefix of the patches
#
# For BR2_GLOBAL_PATCH_DIR, only generate if it is defined
$(BUILD_DIR)/%/.stamp_patched: NAMEVER = $(RAWNAME)-$($(PKG)_VERSION)
$(BUILD_DIR)/%/.stamp_patched: PATCH_BASE_DIRS =  $(PKGDIR)
$(BUILD_DIR)/%/.stamp_patched: PATCH_BASE_DIRS += $(addsuffix /$(RAWNAME),$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)))
$(BUILD_DIR)/%/.stamp_patched:
	@$(call step_start,patch)
	@$(call MESSAGE,"Patching")
	$(foreach hook,$($(PKG)_PRE_PATCH_HOOKS),$(call $(hook))$(sep))
	$(foreach p,$($(PKG)_PATCH),support/scripts/apply-patches.sh $(@D) $(DL_DIR) $(notdir $(p))$(sep))
	$(Q)( \
	for D in $(PATCH_BASE_DIRS); do \
	  if test -d $${D}; then \
	    if test -d $${D}/$($(PKG)_VERSION); then \
	      support/scripts/apply-patches.sh $(@D) $${D}/$($(PKG)_VERSION) \*.patch \*.patch.$(ARCH) || exit 1; \
	    else \
	      support/scripts/apply-patches.sh $(@D) $${D} \*.patch \*.patch.$(ARCH) || exit 1; \
	    fi; \
	  fi; \
	done; \
	)
	$(foreach hook,$($(PKG)_POST_PATCH_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,patch)

# Configure
$(BUILD_DIR)/%/.stamp_configured:
	@$(call step_start,configure)
	@$(call MESSAGE,"Configuring")
	$(foreach hook,$($(PKG)_PRE_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$($(PKG)_CONFIGURE_CMDS)
	$(foreach hook,$($(PKG)_POST_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,configure)

# Build
$(BUILD_DIR)/%/.stamp_built::
	@$(call step_start,build)
	@$(call MESSAGE,"Building")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,build)

# Install to host dir
$(BUILD_DIR)/%/.stamp_host_installed:
	@$(call step_start,install-host)
	@$(call MESSAGE,"Installing to host directory")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,install-host)

# Install to staging dir
$(BUILD_DIR)/%/.stamp_staging_installed:
	@$(call step_start,install-staging)
	@$(call MESSAGE,"Installing to staging directory")
	$(foreach hook,$($(PKG)_PRE_INSTALL_STAGING_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_STAGING_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_STAGING_HOOKS),$(call $(hook))$(sep))
	$(Q)if test -n "$($(PKG)_CONFIG_SCRIPTS)" ; then \
		$(call MESSAGE,"Fixing package configuration files") ;\
			$(SED)  "s,^\(exec_\)\?prefix=.*,\1prefix=$(STAGING_DIR)/usr,g" \
				-e "s,-I/usr/,-I$(STAGING_DIR)/usr/,g" \
				-e "s,-L/usr/,-L$(STAGING_DIR)/usr/,g" \
				$(addprefix $(STAGING_DIR)/usr/bin/,$($(PKG)_CONFIG_SCRIPTS)) ;\
	fi
	$(Q)touch $@
	@$(call step_end,install-staging)

# Install to images dir
$(BUILD_DIR)/%/.stamp_images_installed:
	@$(call step_start,install-image)
	$(foreach hook,$($(PKG)_PRE_INSTALL_IMAGES_HOOKS),$(call $(hook))$(sep))
	@$(call MESSAGE,"Installing to images directory")
	+$($(PKG)_INSTALL_IMAGES_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_IMAGES_HOOKS),$(call $(hook))$(sep))
	$(Q)touch $@
	@$(call step_end,install-image)

# Install to target dir
$(BUILD_DIR)/%/.stamp_target_installed:
	@$(call step_start,install-target)
	@$(call MESSAGE,"Installing to target")
	$(foreach hook,$($(PKG)_PRE_INSTALL_TARGET_HOOKS),$(call $(hook))$(sep))
	$(if $(BR2_INIT_SYSTEMD),\
		$($(PKG)_INSTALL_INIT_SYSTEMD))
	$(if $(BR2_INIT_SYSV)$(BR2_INIT_BUSYBOX),\
		$($(PKG)_INSTALL_INIT_SYSV))
	+$($(PKG)_INSTALL_TARGET_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_TARGET_HOOKS),$(call $(hook))$(sep))
	$(Q)if test -n "$($(PKG)_CONFIG_SCRIPTS)" ; then \
		$(RM) -f $(addprefix $(TARGET_DIR)/usr/bin/,$($(PKG)_CONFIG_SCRIPTS)) ; \
	fi
	$(Q)touch $@
	@$(call step_end,install-target)

# Remove package sources
$(BUILD_DIR)/%/.stamp_dircleaned:
	rm -Rf $(@D)

################################################################################
# inner-generic-package -- generates the make targets needed to build a
# generic package
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including an HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
################################################################################

define inner-generic-package

# Define default values for various package-related variables, if not
# already defined. For some variables (version, source, site and
# subdir), if they are undefined, we try to see if a variable without
# the HOST_ prefix is defined. If so, we use such a variable, so that
# these informations have only to be specified once, for both the
# target and host packages of a given .mk file.

$(2)_TYPE                       =  $(4)
$(2)_NAME			=  $(1)
$(2)_RAWNAME			=  $(patsubst host-%,%,$(1))

# Keep the package version that may contain forward slashes in the _DL_VERSION
# variable, then replace all forward slashes ('/') by underscores ('_') to
# sanitize the package version that is used in paths, directory and file names.
# Forward slashes may appear in the package's version when pointing to a
# version control system branch or tag, for example remotes/origin/1_10_stable.
ifndef $(2)_VERSION
 ifdef $(3)_VERSION
  $(2)_DL_VERSION = $($(3)_VERSION)
  $(2)_VERSION = $(subst /,_,$($(3)_VERSION))
 else
  $(2)_VERSION = undefined
  $(2)_DL_VERSION = undefined
 endif
else
  $(2)_DL_VERSION = $($(2)_VERSION)
  $(2)_VERSION = $(subst /,_,$($(2)_VERSION))
endif

$(2)_BASE_NAME	=  $(1)-$$($(2)_VERSION)
$(2)_DL_DIR	=  $$(DL_DIR)/$$($(2)_BASE_NAME)
$(2)_DIR	=  $$(BUILD_DIR)/$$($(2)_BASE_NAME)

ifndef $(2)_SUBDIR
 ifdef $(3)_SUBDIR
  $(2)_SUBDIR = $$($(3)_SUBDIR)
 else
  $(2)_SUBDIR ?=
 endif
endif

$(2)_SRCDIR		       = $$($(2)_DIR)/$$($(2)_SUBDIR)
$(2)_BUILDDIR		       ?= $$($(2)_SRCDIR)

ifneq ($$($(2)_OVERRIDE_SRCDIR),)
$(2)_VERSION = custom
endif

ifndef $(2)_SOURCE
 ifdef $(3)_SOURCE
  $(2)_SOURCE = $($(3)_SOURCE)
 else
  $(2)_SOURCE			?= $$($(2)_RAWNAME)-$$($(2)_VERSION).tar.gz
 endif
endif

ifndef $(2)_PATCH
 ifdef $(3)_PATCH
  $(2)_PATCH = $($(3)_PATCH)
 endif
endif

ifndef $(2)_SITE
 ifdef $(3)_SITE
  $(2)_SITE = $($(3)_SITE)
 endif
endif

ifndef $(2)_SITE_METHOD
 ifdef $(3)_SITE_METHOD
  $(2)_SITE_METHOD = $($(3)_SITE_METHOD)
 else
	# Try automatic detection using the scheme part of the URI
	$(2)_SITE_METHOD = $(call geturischeme,$($(2)_SITE))
 endif
endif

ifeq ($$($(2)_SITE_METHOD),local)
ifeq ($$($(2)_OVERRIDE_SRCDIR),)
$(2)_OVERRIDE_SRCDIR = $$($(2)_SITE)
endif
endif

ifndef $(2)_LICENSE
 ifdef $(3)_LICENSE
  $(2)_LICENSE = $($(3)_LICENSE)
 endif
endif

$(2)_LICENSE			?= unknown

ifndef $(2)_LICENSE_FILES
 ifdef $(3)_LICENSE_FILES
  $(2)_LICENSE_FILES = $($(3)_LICENSE_FILES)
 endif
endif

ifndef $(2)_REDISTRIBUTE
 ifdef $(3)_REDISTRIBUTE
  $(2)_REDISTRIBUTE = $($(3)_REDISTRIBUTE)
 endif
endif

$(2)_REDISTRIBUTE		?= YES

# When a target package is a toolchain dependency set this variable to
# 'NO' so the 'toolchain' dependency is not added to prevent a circular
# dependency
$(2)_ADD_TOOLCHAIN_DEPENDENCY	?= YES

$(2)_DEPENDENCIES ?= $(filter-out  host-toolchain $(1),\
	$(patsubst host-host-%,host-%,$(addprefix host-,$($(3)_DEPENDENCIES))))
ifeq ($(4),target)
ifeq ($$($(2)_ADD_TOOLCHAIN_DEPENDENCY),YES)
$(2)_DEPENDENCIES += toolchain
endif
endif

$(2)_INSTALL_STAGING		?= NO
$(2)_INSTALL_IMAGES		?= NO
$(2)_INSTALL_TARGET		?= YES

# define sub-target stamps
$(2)_TARGET_INSTALL_TARGET =	$$($(2)_DIR)/.stamp_target_installed
$(2)_TARGET_INSTALL_STAGING =	$$($(2)_DIR)/.stamp_staging_installed
$(2)_TARGET_INSTALL_IMAGES =	$$($(2)_DIR)/.stamp_images_installed
$(2)_TARGET_INSTALL_HOST =      $$($(2)_DIR)/.stamp_host_installed
$(2)_TARGET_BUILD =		$$($(2)_DIR)/.stamp_built
$(2)_TARGET_CONFIGURE =		$$($(2)_DIR)/.stamp_configured
$(2)_TARGET_RSYNC =	        $$($(2)_DIR)/.stamp_rsynced
$(2)_TARGET_RSYNC_SOURCE =      $$($(2)_DIR)/.stamp_rsync_sourced
$(2)_TARGET_PATCH =		$$($(2)_DIR)/.stamp_patched
$(2)_TARGET_EXTRACT =		$$($(2)_DIR)/.stamp_extracted
$(2)_TARGET_SOURCE =		$$($(2)_DIR)/.stamp_downloaded
$(2)_TARGET_DIRCLEAN =		$$($(2)_DIR)/.stamp_dircleaned

# default extract command
$(2)_EXTRACT_CMDS ?= \
	$$(if $$($(2)_SOURCE),$$(INFLATE$$(suffix $$($(2)_SOURCE))) $(DL_DIR)/$$($(2)_SOURCE) | \
	$(TAR) $(TAR_STRIP_COMPONENTS)=1 -C $$($(2)_DIR) $(TAR_OPTIONS) -)

# pre/post-steps hooks
$(2)_PRE_DOWNLOAD_HOOKS         ?=
$(2)_POST_DOWNLOAD_HOOKS        ?=
$(2)_PRE_EXTRACT_HOOKS          ?=
$(2)_POST_EXTRACT_HOOKS         ?=
$(2)_PRE_RSYNC_HOOKS            ?=
$(2)_POST_RSYNC_HOOKS           ?=
$(2)_PRE_PATCH_HOOKS            ?=
$(2)_POST_PATCH_HOOKS           ?=
$(2)_PRE_CONFIGURE_HOOKS        ?=
$(2)_POST_CONFIGURE_HOOKS       ?=
$(2)_PRE_BUILD_HOOKS            ?=
$(2)_POST_BUILD_HOOKS           ?=
$(2)_PRE_INSTALL_HOOKS          ?=
$(2)_POST_INSTALL_HOOKS         ?=
$(2)_PRE_INSTALL_STAGING_HOOKS  ?=
$(2)_POST_INSTALL_STAGING_HOOKS ?=
$(2)_PRE_INSTALL_TARGET_HOOKS   ?=
$(2)_POST_INSTALL_TARGET_HOOKS  ?=
$(2)_PRE_INSTALL_IMAGES_HOOKS   ?=
$(2)_POST_INSTALL_IMAGES_HOOKS  ?=
$(2)_PRE_LEGAL_INFO_HOOKS       ?=
$(2)_POST_LEGAL_INFO_HOOKS      ?=

# human-friendly targets and target sequencing
$(1):			$(1)-install

ifeq ($$($(2)_TYPE),host)
$(1)-install:	        $(1)-install-host
else
$(1)-install:		$(1)-install-staging $(1)-install-target $(1)-install-images
endif

ifeq ($$($(2)_INSTALL_TARGET),YES)
$(1)-install-target:		$$($(2)_TARGET_INSTALL_TARGET)
$$($(2)_TARGET_INSTALL_TARGET):	$$($(2)_TARGET_BUILD)
else
$(1)-install-target:
endif

ifeq ($$($(2)_INSTALL_STAGING),YES)
$(1)-install-staging:			$$($(2)_TARGET_INSTALL_STAGING)
$$($(2)_TARGET_INSTALL_STAGING):	$$($(2)_TARGET_BUILD)
# Some packages use install-staging stuff for install-target
$$($(2)_TARGET_INSTALL_TARGET):		$$($(2)_TARGET_INSTALL_STAGING)
else
$(1)-install-staging:
endif

ifeq ($$($(2)_INSTALL_IMAGES),YES)
$(1)-install-images:		$$($(2)_TARGET_INSTALL_IMAGES)
$$($(2)_TARGET_INSTALL_IMAGES):	$$($(2)_TARGET_BUILD)
else
$(1)-install-images:
endif

$(1)-install-host:      	$$($(2)_TARGET_INSTALL_HOST)
$$($(2)_TARGET_INSTALL_HOST):	$$($(2)_TARGET_BUILD)

$(1)-build:		$$($(2)_TARGET_BUILD)
$$($(2)_TARGET_BUILD):	$$($(2)_TARGET_CONFIGURE)

# Since $(2)_DEPENDENCIES are phony targets, they are always "newer"
# than $(2)_TARGET_CONFIGURE. This would force the configure step (and
# therefore the other steps as well) to be re-executed with every
# invocation of make.  Therefore, make $(2)_DEPENDENCIES an order-only
# dependency by using |.

$(1)-configure:			$$($(2)_TARGET_CONFIGURE)
$$($(2)_TARGET_CONFIGURE):	| $$($(2)_DEPENDENCIES)

$$($(2)_TARGET_SOURCE) $$($(2)_TARGET_RSYNC): | dirs prepare
ifeq ($(filter $(1),$(DEPENDENCIES_HOST_PREREQ)),)
$$($(2)_TARGET_SOURCE) $$($(2)_TARGET_RSYNC): | dependencies
endif

ifeq ($$($(2)_OVERRIDE_SRCDIR),)
# In the normal case (no package override), the sequence of steps is
#  source, by downloading
#  depends
#  extract
#  patch
#  configure
$$($(2)_TARGET_CONFIGURE):	$$($(2)_TARGET_PATCH)

$(1)-patch:		$$($(2)_TARGET_PATCH)
$$($(2)_TARGET_PATCH):	$$($(2)_TARGET_EXTRACT)

$(1)-extract:			$$($(2)_TARGET_EXTRACT)
$$($(2)_TARGET_EXTRACT):	$$($(2)_TARGET_SOURCE)

$(1)-depends:		$$($(2)_DEPENDENCIES)

$(1)-source:		$$($(2)_TARGET_SOURCE)
else
# In the package override case, the sequence of steps
#  source, by rsyncing
#  depends
#  configure
$$($(2)_TARGET_CONFIGURE):	$$($(2)_TARGET_RSYNC)

$(1)-depends:		$$($(2)_DEPENDENCIES)

$(1)-patch:		$(1)-rsync
$(1)-extract:		$(1)-rsync

$(1)-rsync:		$$($(2)_TARGET_RSYNC)

$(1)-source:		$$($(2)_TARGET_RSYNC_SOURCE)
endif

$(1)-show-depends:
			@echo $$($(2)_DEPENDENCIES)

$(1)-graph-depends:
			@$(INSTALL) -d $(O)/graphs
			@cd "$(CONFIG_DIR)"; \
			$(TOPDIR)/support/scripts/graph-depends -p $(1) -d $(BR_GRAPH_DEPTH) \
			|tee $(O)/graphs/$$(@).dot \
			|dot -T$(BR_GRAPH_OUT) -o $(O)/graphs/$$(@).$(BR_GRAPH_OUT)

$(1)-dirclean:		$$($(2)_TARGET_DIRCLEAN)

$(1)-clean-for-rebuild:
ifneq ($$($(2)_OVERRIDE_SRCDIR),)
			rm -f $$($(2)_TARGET_RSYNC)
endif
			rm -f $$($(2)_TARGET_BUILD)
			rm -f $$($(2)_TARGET_INSTALL_STAGING)
			rm -f $$($(2)_TARGET_INSTALL_TARGET)
			rm -f $$($(2)_TARGET_INSTALL_IMAGES)
			rm -f $$($(2)_TARGET_INSTALL_HOST)

$(1)-rebuild:		$(1)-clean-for-rebuild $(1)

$(1)-clean-for-reconfigure: $(1)-clean-for-rebuild
			rm -f $$($(2)_TARGET_CONFIGURE)

$(1)-reconfigure:	$(1)-clean-for-reconfigure $(1)

# define the PKG variable for all targets, containing the
# uppercase package variable prefix
$$($(2)_TARGET_INSTALL_TARGET):		PKG=$(2)
$$($(2)_TARGET_INSTALL_STAGING):	PKG=$(2)
$$($(2)_TARGET_INSTALL_IMAGES):		PKG=$(2)
$$($(2)_TARGET_INSTALL_HOST):           PKG=$(2)
$$($(2)_TARGET_BUILD):			PKG=$(2)
$$($(2)_TARGET_CONFIGURE):		PKG=$(2)
$$($(2)_TARGET_RSYNC):                  SRCDIR=$$($(2)_OVERRIDE_SRCDIR)
$$($(2)_TARGET_RSYNC):                  PKG=$(2)
$$($(2)_TARGET_RSYNC_SOURCE):		SRCDIR=$$($(2)_OVERRIDE_SRCDIR)
$$($(2)_TARGET_RSYNC_SOURCE):		PKG=$(2)
$$($(2)_TARGET_PATCH):			PKG=$(2)
$$($(2)_TARGET_PATCH):			RAWNAME=$(patsubst host-%,%,$(1))
$$($(2)_TARGET_PATCH):			PKGDIR=$(pkgdir)
$$($(2)_TARGET_EXTRACT):		PKG=$(2)
$$($(2)_TARGET_SOURCE):			PKG=$(2)
$$($(2)_TARGET_DIRCLEAN):		PKG=$(2)

# Compute the name of the Kconfig option that correspond to the
# package being enabled. We handle three cases: the special Linux
# kernel case, the bootloaders case, and the normal packages case.
ifeq ($(1),linux)
$(2)_KCONFIG_VAR = BR2_LINUX_KERNEL
else ifneq ($(filter boot/%,$(pkgdir)),)
$(2)_KCONFIG_VAR = BR2_TARGET_$(2)
else ifneq ($(filter toolchain/%,$(pkgdir)),)
$(2)_KCONFIG_VAR = BR2_$(2)
else
$(2)_KCONFIG_VAR = BR2_PACKAGE_$(2)
endif

# legal-info: declare dependencies and set values used later for the manifest
ifneq ($$($(2)_LICENSE_FILES),)
$(2)_MANIFEST_LICENSE_FILES = $$($(2)_LICENSE_FILES)
endif
$(2)_MANIFEST_LICENSE_FILES ?= not saved

ifeq ($$($(2)_REDISTRIBUTE),YES)
ifneq ($$($(2)_SITE_METHOD),local)
ifneq ($$($(2)_SITE_METHOD),override)
# Packages that have a tarball need it downloaded and extracted beforehand
$(1)-legal-info: $(1)-extract $(REDIST_SOURCES_DIR_$(call UPPERCASE,$(4)))
$(2)_MANIFEST_TARBALL = $$($(2)_SOURCE)
endif
endif
endif
$(2)_MANIFEST_TARBALL ?= not saved

# legal-info: produce legally relevant info.
$(1)-legal-info:
# Packages without a source are assumed to be part of Buildroot, skip them.
	$(foreach hook,$($(2)_PRE_LEGAL_INFO_HOOKS),$(call $(hook))$(sep))
ifneq ($(call qstrip,$$($(2)_SOURCE)),)

ifeq ($$($(2)_SITE_METHOD),local)
# Packages without a tarball: don't save and warn
	@$(call legal-warning-pkg-savednothing,$$($(2)_RAWNAME),local)

else ifneq ($$($(2)_OVERRIDE_SRCDIR),)
	@$(call legal-warning-pkg-savednothing,$$($(2)_RAWNAME),override)

else
# Other packages

# Save license files if defined
ifeq ($(call qstrip,$$($(2)_LICENSE_FILES)),)
	@$(call legal-license-nofiles,$$($(2)_RAWNAME),$(call UPPERCASE,$(4)))
	@$(call legal-warning-pkg,$$($(2)_RAWNAME),cannot save license ($(2)_LICENSE_FILES not defined))
else
# Double dollar signs are really needed here, to catch host packages
# without explicit HOST_FOO_LICENSE_FILES assignment, also in case they
# have multiple license files.
	@$$(foreach F,$$($(2)_LICENSE_FILES),$$(call legal-license-file,$$($(2)_RAWNAME),$$(F),$$($(2)_DIR)/$$(F),$(call UPPERCASE,$(4)))$$(sep))
endif # license files

ifeq ($$($(2)_REDISTRIBUTE),YES)
# Copy the source tarball (just hardlink if possible)
	@cp -l $(DL_DIR)/$$($(2)_SOURCE) $(REDIST_SOURCES_DIR_$(call UPPERCASE,$(4))) 2>/dev/null || \
	   cp $(DL_DIR)/$$($(2)_SOURCE) $(REDIST_SOURCES_DIR_$(call UPPERCASE,$(4)))
endif # redistribute

endif # other packages
	@$(call legal-manifest,$$($(2)_RAWNAME),$$($(2)_VERSION),$$($(2)_LICENSE),$$($(2)_MANIFEST_LICENSE_FILES),$$($(2)_MANIFEST_TARBALL),$(call UPPERCASE,$(4)))
endif # ifneq ($(call qstrip,$$($(2)_SOURCE)),)
	$(foreach hook,$($(2)_POST_LEGAL_INFO_HOOKS),$(call $(hook))$(sep))

# add package to the general list of targets if requested by the buildroot
# configuration
ifeq ($$($$($(2)_KCONFIG_VAR)),y)

TARGETS += $(1)
PACKAGES_PERMISSIONS_TABLE += $$($(2)_PERMISSIONS)$$(sep)
PACKAGES_DEVICES_TABLE += $$($(2)_DEVICES)$$(sep)
PACKAGES_USERS += $$($(2)_USERS)$$(sep)

ifeq ($$($(2)_SITE_METHOD),svn)
DL_TOOLS_DEPENDENCIES += svn
else ifeq ($$($(2)_SITE_METHOD),git)
DL_TOOLS_DEPENDENCIES += git
else ifeq ($$($(2)_SITE_METHOD),bzr)
DL_TOOLS_DEPENDENCIES += bzr
else ifeq ($$($(2)_SITE_METHOD),scp)
DL_TOOLS_DEPENDENCIES += scp ssh
else ifeq ($$($(2)_SITE_METHOD),hg)
DL_TOOLS_DEPENDENCIES += hg
else ifeq ($$($(2)_SITE_METHOD),cvs)
DL_TOOLS_DEPENDENCIES += cvs
endif # SITE_METHOD

# $(firstword) is used here because the extractor can have arguments, like
# ZCAT="gzip -d -c", and to check for the dependency we only want 'gzip'.
# Do not add xzcat to the list of required dependencies, as it gets built
# automatically if it isn't found.
ifneq ($(call suitable-extractor,$($(2)_SOURCE)),$(XZCAT))
DL_TOOLS_DEPENDENCIES += $(firstword $(call suitable-extractor,$($(2)_SOURCE)))
endif

endif # $(2)_KCONFIG_VAR
endef # inner-generic-package

################################################################################
# generic-package -- the target generator macro for generic packages
################################################################################

# In the case of target packages, keep the package name "pkg"
generic-package = $(call inner-generic-package,$(pkgname),$(call UPPERCASE,$(pkgname)),$(call UPPERCASE,$(pkgname)),target)
# In the case of host packages, turn the package name "pkg" into "host-pkg"
host-generic-package = $(call inner-generic-package,host-$(pkgname),$(call UPPERCASE,host-$(pkgname)),$(call UPPERCASE,$(pkgname)),host)

# :mode=makefile:
