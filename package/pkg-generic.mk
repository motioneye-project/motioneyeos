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
#   1. Metadata information about the package: name, version,
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
	       "$$(date +%s.%N)" "$(1)" "$(2)" "$(3)"  \
	       >>"$(BUILD_DIR)/build-time.log"
endef
GLOBAL_INSTRUMENTATION_HOOKS += step_time

# Hooks to collect statistics about installed files

# $(1): package name
# $(2): base directory to search in
# $(3): suffix of file (optional)
define step_pkg_size_before
	cd $(2); \
	LC_ALL=C find . \( -type f -o -type l \) -printf '%T@:%i:%#m:%y:%s,%p\n' \
		| LC_ALL=C sort > $($(PKG)_DIR)/.files-list$(3).before
endef

# $(1): package name
# $(2): base directory to search in
# $(3): suffix of file (optional)
define step_pkg_size_after
	cd $(2); \
	LC_ALL=C find . \( -type f -o -type l \) -printf '%T@:%i:%#m:%y:%s,%p\n' \
		| LC_ALL=C sort > $($(PKG)_DIR)/.files-list$(3).after
	LC_ALL=C comm -13 \
		$($(PKG)_DIR)/.files-list$(3).before \
		$($(PKG)_DIR)/.files-list$(3).after \
		| sed -r -e 's/^[^,]+/$(1)/' \
		> $($(PKG)_DIR)/.files-list$(3).txt
	rm -f $($(PKG)_DIR)/.files-list$(3).before
	rm -f $($(PKG)_DIR)/.files-list$(3).after
endef

define step_pkg_size
	$(if $(filter start-install-target,$(1)-$(2)),\
		$(call step_pkg_size_before,$(3),$(TARGET_DIR)))
	$(if $(filter start-install-staging,$(1)-$(2)),\
		$(call step_pkg_size_before,$(3),$(STAGING_DIR),-staging))
	$(if $(filter start-install-host,$(1)-$(2)),\
		$(call step_pkg_size_before,$(3),$(HOST_DIR),-host))

	$(if $(filter end-install-target,$(1)-$(2)),\
		$(call step_pkg_size_after,$(3),$(TARGET_DIR)))
	$(if $(filter end-install-staging,$(1)-$(2)),\
		$(call step_pkg_size_after,$(3),$(STAGING_DIR),-staging))
	$(if $(filter end-install-host,$(1)-$(2)),\
		$(call step_pkg_size_after,$(3),$(HOST_DIR),-host))
endef
GLOBAL_INSTRUMENTATION_HOOKS += step_pkg_size

# Relies on step_pkg_size, so must be after
define check_bin_arch
	$(if $(filter end-install-target,$(1)-$(2)),\
		support/scripts/check-bin-arch -p $(3) \
			-l $($(PKG)_DIR)/.files-list.txt \
			$(foreach i,$($(PKG)_BIN_ARCH_EXCLUDE),-i "$(i)") \
			-r $(TARGET_READELF) \
			-a $(BR2_READELF_ARCH_NAME))
endef

GLOBAL_INSTRUMENTATION_HOOKS += check_bin_arch

# This hook checks that host packages that need libraries that we build
# have a proper DT_RPATH or DT_RUNPATH tag
define check_host_rpath
	$(if $(filter install-host,$(2)),\
		$(if $(filter end,$(1)),support/scripts/check-host-rpath $(3) $(HOST_DIR) $(PER_PACKAGE_DIR)))
endef
GLOBAL_INSTRUMENTATION_HOOKS += check_host_rpath

define step_check_build_dir_one
	if [ -d $(2) ]; then \
		printf "%s: installs files in %s\n" $(1) $(2) >&2; \
		exit 1; \
	fi
endef

define step_check_build_dir
	$(if $(filter install-staging,$(2)),\
		$(if $(filter end,$(1)),$(call step_check_build_dir_one,$(3),$(STAGING_DIR)/$(O))))
	$(if $(filter install-target,$(2)),\
		$(if $(filter end,$(1)),$(call step_check_build_dir_one,$(3),$(TARGET_DIR)/$(O))))
endef
GLOBAL_INSTRUMENTATION_HOOKS += step_check_build_dir

# User-supplied script
ifneq ($(BR2_INSTRUMENTATION_SCRIPTS),)
define step_user
	@$(foreach user_hook, $(BR2_INSTRUMENTATION_SCRIPTS), \
		$(EXTRA_ENV) $(user_hook) "$(1)" "$(2)" "$(3)"$(sep))
endef
GLOBAL_INSTRUMENTATION_HOOKS += step_user
endif

#######################################
# Helper functions

# Make sure .la files only reference the current per-package
# directory.

# $1: package name (lower case)
# $2: staging directory of the package
ifeq ($(BR2_PER_PACKAGE_DIRECTORIES),y)
define fixup-libtool-files
	$(Q)find $(2)/usr/lib* -name "*.la" | xargs --no-run-if-empty \
		$(SED) "s:$(PER_PACKAGE_DIR)/[^/]\+/:$(PER_PACKAGE_DIR)/$(1)/:g"
endef
endif

################################################################################
# Implicit targets -- produce a stamp file for each step of a package build
################################################################################

# Retrieve the archive
$(BUILD_DIR)/%/.stamp_downloaded:
	@$(call step_start,download)
	$(call prepare-per-package-directory,$($(PKG)_FINAL_DOWNLOAD_DEPENDENCIES))
	$(foreach hook,$($(PKG)_PRE_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
# Only show the download message if it isn't already downloaded
	$(Q)for p in $($(PKG)_ALL_DOWNLOADS); do \
		if test ! -e $($(PKG)_DL_DIR)/`basename $$p` ; then \
			$(call MESSAGE,"Downloading") ; \
			break ; \
		fi ; \
	done
	$(foreach p,$($(PKG)_ALL_DOWNLOADS),$(call DOWNLOAD,$(p),$(PKG))$(sep))
	$(foreach hook,$($(PKG)_POST_DOWNLOAD_HOOKS),$(call $(hook))$(sep))
	$(Q)mkdir -p $(@D)
	@$(call step_end,download)
	$(Q)touch $@

# Retrieve actual source archive, e.g. for prebuilt external toolchains
$(BUILD_DIR)/%/.stamp_actual_downloaded:
	@$(call step_start,actual-download)
	$(call DOWNLOAD,$($(PKG)_ACTUAL_SOURCE_SITE)/$($(PKG)_ACTUAL_SOURCE_TARBALL),$(PKG))
	$(Q)mkdir -p $(@D)
	@$(call step_end,actual-download)
	$(Q)touch $@

# Unpack the archive
$(BUILD_DIR)/%/.stamp_extracted:
	@$(call step_start,extract)
	@$(call MESSAGE,"Extracting")
	$(call prepare-per-package-directory,$($(PKG)_FINAL_EXTRACT_DEPENDENCIES))
	$(foreach hook,$($(PKG)_PRE_EXTRACT_HOOKS),$(call $(hook))$(sep))
	$(Q)mkdir -p $(@D)
	$($(PKG)_EXTRACT_CMDS)
# some packages have messed up permissions inside
	$(Q)chmod -R +rw $(@D)
	$(foreach hook,$($(PKG)_POST_EXTRACT_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,extract)
	$(Q)touch $@

# Rsync the source directory if the <pkg>_OVERRIDE_SRCDIR feature is
# used.
$(BUILD_DIR)/%/.stamp_rsynced:
	@$(call step_start,rsync)
	@$(call MESSAGE,"Syncing from source dir $(SRCDIR)")
	@mkdir -p $(@D)
	$(foreach hook,$($(PKG)_PRE_RSYNC_HOOKS),$(call $(hook))$(sep))
	@test -d $(SRCDIR) || (echo "ERROR: $(SRCDIR) does not exist" ; exit 1)
	rsync -au --chmod=u=rwX,go=rX $($(PKG)_OVERRIDE_SRCDIR_RSYNC_EXCLUSIONS) $(RSYNC_VCS_EXCLUSIONS) $(call qstrip,$(SRCDIR))/ $(@D)
	$(foreach hook,$($(PKG)_POST_RSYNC_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,rsync)
	$(Q)touch $@

# Patch
#
# The RAWNAME variable is the lowercased package name, which allows to
# find the package directory (typically package/<pkgname>) and the
# prefix of the patches
#
# For BR2_GLOBAL_PATCH_DIR, only generate if it is defined
$(BUILD_DIR)/%/.stamp_patched: PATCH_BASE_DIRS =  $(PKGDIR)
$(BUILD_DIR)/%/.stamp_patched: PATCH_BASE_DIRS += $(addsuffix /$(RAWNAME),$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)))
$(BUILD_DIR)/%/.stamp_patched:
	@$(call step_start,patch)
	@$(call MESSAGE,"Patching")
	$(foreach hook,$($(PKG)_PRE_PATCH_HOOKS),$(call $(hook))$(sep))
	$(foreach p,$($(PKG)_PATCH),$(APPLY_PATCHES) $(@D) $($(PKG)_DL_DIR) $(notdir $(p))$(sep))
	$(Q)( \
	for D in $(PATCH_BASE_DIRS); do \
	  if test -d $${D}; then \
	    if test -d $${D}/$($(PKG)_VERSION); then \
	      $(APPLY_PATCHES) $(@D) $${D}/$($(PKG)_VERSION) \*.patch \*.patch.$(ARCH) || exit 1; \
	    else \
	      $(APPLY_PATCHES) $(@D) $${D} \*.patch \*.patch.$(ARCH) || exit 1; \
	    fi; \
	  fi; \
	done; \
	)
	$(foreach hook,$($(PKG)_POST_PATCH_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,patch)
	$(Q)touch $@

# Check that all directories specified in BR2_GLOBAL_PATCH_DIR exist.
$(foreach dir,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)),\
	$(if $(wildcard $(dir)),,\
		$(error BR2_GLOBAL_PATCH_DIR contains nonexistent directory $(dir))))

# Configure
$(BUILD_DIR)/%/.stamp_configured:
	@$(call step_start,configure)
	@$(call MESSAGE,"Configuring")
	$(call prepare-per-package-directory,$($(PKG)_FINAL_DEPENDENCIES))
	$(call fixup-libtool-files,$(NAME),$(STAGING_DIR))
	$(foreach hook,$($(PKG)_PRE_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	$($(PKG)_CONFIGURE_CMDS)
	$(foreach hook,$($(PKG)_POST_CONFIGURE_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,configure)
	$(Q)touch $@

# Build
$(BUILD_DIR)/%/.stamp_built::
	@$(call step_start,build)
	@$(call MESSAGE,"Building")
	$(foreach hook,$($(PKG)_PRE_BUILD_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_BUILD_CMDS)
	$(foreach hook,$($(PKG)_POST_BUILD_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,build)
	$(Q)touch $@

# Install to host dir
$(BUILD_DIR)/%/.stamp_host_installed:
	@mkdir -p $(HOST_DIR)
	@$(call step_start,install-host)
	@$(call MESSAGE,"Installing to host directory")
	$(foreach hook,$($(PKG)_PRE_INSTALL_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,install-host)
	$(Q)touch $@

# Install to staging dir
#
# Some packages install libtool .la files alongside any installed
# libraries. These .la files sometimes refer to paths relative to the
# sysroot, which libtool will interpret as absolute paths to host
# libraries instead of the target libraries. Since this is not what we
# want, these paths are fixed by prefixing them with $(STAGING_DIR).
# As we configure with --prefix=/usr, this fix needs to be applied to
# any path that starts with /usr.
#
# To protect against the case that the output or staging directories or
# the pre-installed external toolchain themselves are under /usr, we first
# substitute away any occurrences of these directories with @BASE_DIR@,
# @STAGING_DIR@ and @TOOLCHAIN_EXTERNAL_INSTALL_DIR@ respectively.
#
# Note that STAGING_DIR can be outside BASE_DIR when the user sets
# BR2_HOST_DIR to a custom value. Note that TOOLCHAIN_EXTERNAL_INSTALL_DIR
# can be under @BASE_DIR@ when it's a downloaded toolchain, and can be
# empty when we use an internal toolchain.
#
$(BUILD_DIR)/%/.stamp_staging_installed:
	@mkdir -p $(STAGING_DIR)
	@$(call step_start,install-staging)
	@$(call MESSAGE,"Installing to staging directory")
	$(foreach hook,$($(PKG)_PRE_INSTALL_STAGING_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_STAGING_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_STAGING_HOOKS),$(call $(hook))$(sep))
	$(Q)if test -n "$($(PKG)_CONFIG_SCRIPTS)" ; then \
		$(call MESSAGE,"Fixing package configuration files") ;\
			$(SED)  "s,$(HOST_DIR),@HOST_DIR@,g" \
				-e "s,$(BASE_DIR),@BASE_DIR@,g" \
				-e "s,^\(exec_\)\?prefix=.*,\1prefix=@STAGING_DIR@/usr,g" \
				-e "s,-I/usr/,-I@STAGING_DIR@/usr/,g" \
				-e "s,-L/usr/,-L@STAGING_DIR@/usr/,g" \
				-e 's,@STAGING_DIR@,$$(dirname $$(readlink -e $$0))/../..,g' \
				-e 's,@HOST_DIR@,$$(dirname $$(readlink -e $$0))/../../../..,g' \
				-e "s,@BASE_DIR@,$(BASE_DIR),g" \
				$(addprefix $(STAGING_DIR)/usr/bin/,$($(PKG)_CONFIG_SCRIPTS)) ;\
	fi
	@$(call MESSAGE,"Fixing libtool files")
	for la in $$(find $(STAGING_DIR)/usr/lib* -name "*.la"); do \
		cp -a "$${la}" "$${la}.fixed" && \
		$(SED) "s:$(BASE_DIR):@BASE_DIR@:g" \
			-e "s:$(STAGING_DIR):@STAGING_DIR@:g" \
			$(if $(TOOLCHAIN_EXTERNAL_INSTALL_DIR),\
				-e "s:$(TOOLCHAIN_EXTERNAL_INSTALL_DIR):@TOOLCHAIN_EXTERNAL_INSTALL_DIR@:g") \
			-e "s:\(['= ]\)/usr:\\1@STAGING_DIR@/usr:g" \
			-e "s:\(['= ]\)/lib:\\1@STAGING_DIR@/lib:g" \
			$(if $(TOOLCHAIN_EXTERNAL_INSTALL_DIR),\
				-e "s:@TOOLCHAIN_EXTERNAL_INSTALL_DIR@:$(TOOLCHAIN_EXTERNAL_INSTALL_DIR):g") \
			-e "s:@STAGING_DIR@:$(STAGING_DIR):g" \
			-e "s:@BASE_DIR@:$(BASE_DIR):g" \
			"$${la}.fixed" && \
		if cmp -s "$${la}" "$${la}.fixed"; then \
			rm -f "$${la}.fixed"; \
		else \
			mv "$${la}.fixed" "$${la}"; \
		fi || exit 1; \
	done
	@$(call step_end,install-staging)
	$(Q)touch $@

# Install to images dir
$(BUILD_DIR)/%/.stamp_images_installed:
	@mkdir -p $(BINARIES_DIR)
	@$(call step_start,install-image)
	@$(call MESSAGE,"Installing to images directory")
	$(foreach hook,$($(PKG)_PRE_INSTALL_IMAGES_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_IMAGES_CMDS)
	$(foreach hook,$($(PKG)_POST_INSTALL_IMAGES_HOOKS),$(call $(hook))$(sep))
	@$(call step_end,install-image)
	$(Q)touch $@

# Install to target dir
$(BUILD_DIR)/%/.stamp_target_installed:
	@mkdir -p $(TARGET_DIR)
	@$(call step_start,install-target)
	@$(call MESSAGE,"Installing to target")
	$(foreach hook,$($(PKG)_PRE_INSTALL_TARGET_HOOKS),$(call $(hook))$(sep))
	+$($(PKG)_INSTALL_TARGET_CMDS)
	$(if $(BR2_INIT_SYSTEMD),\
		$($(PKG)_INSTALL_INIT_SYSTEMD))
	$(if $(BR2_INIT_SYSV)$(BR2_INIT_BUSYBOX),\
		$($(PKG)_INSTALL_INIT_SYSV))
	$(if $(BR2_INIT_OPENRC), \
		$(or $($(PKG)_INSTALL_INIT_OPENRC), \
			$($(PKG)_INSTALL_INIT_SYSV)))
	$(foreach hook,$($(PKG)_POST_INSTALL_TARGET_HOOKS),$(call $(hook))$(sep))
	$(Q)if test -n "$($(PKG)_CONFIG_SCRIPTS)" ; then \
		$(RM) -f $(addprefix $(TARGET_DIR)/usr/bin/,$($(PKG)_CONFIG_SCRIPTS)) ; \
	fi
	@$(call step_end,install-target)
	$(Q)touch $@

# Remove package sources
$(BUILD_DIR)/%/.stamp_dircleaned:
	$(if $(BR2_PER_PACKAGE_DIRECTORIES),rm -Rf $(PER_PACKAGE_DIR)/$(NAME))
	rm -Rf $(@D)

################################################################################
# virt-provides-single -- check that provider-pkg is the declared provider for
# the virtual package virt-pkg
#
# argument 1 is the lower-case name of the virtual package
# argument 2 is the upper-case name of the virtual package
# argument 3 is the lower-case name of the provider
#
# example:
#   $(call virt-provides-single,libegl,LIBEGL,rpi-userland)
################################################################################
define virt-provides-single
ifneq ($$(call qstrip,$$(BR2_PACKAGE_PROVIDES_$(2))),$(3))
$$(error Configuration error: both "$(3)" and $$(BR2_PACKAGE_PROVIDES_$(2))\
are selected as providers for virtual package "$(1)". Only one provider can\
be selected at a time. Please fix your configuration)
endif
endef

define pkg-graph-depends
	@$$(INSTALL) -d $$(GRAPHS_DIR)
	@cd "$$(CONFIG_DIR)"; \
	$$(TOPDIR)/support/scripts/graph-depends $$(BR2_GRAPH_DEPS_OPTS) \
		-p $(1) $(2) -o $$(GRAPHS_DIR)/$$(@).dot
	dot $$(BR2_GRAPH_DOT_OPTS) -T$$(BR_GRAPH_OUT) \
		-o $$(GRAPHS_DIR)/$$(@).$$(BR_GRAPH_OUT) \
		$$(GRAPHS_DIR)/$$(@).dot
endef

################################################################################
# inner-generic-package -- generates the make targets needed to build a
# generic package
#
#  argument 1 is the lowercase package name
#  argument 2 is the uppercase package name, including a HOST_ prefix
#             for host packages
#  argument 3 is the uppercase package name, without the HOST_ prefix
#             for host packages
#  argument 4 is the type (target or host)
#
# Note about variable and function references: inside all blocks that are
# evaluated with $(eval), which includes all 'inner-xxx-package' blocks,
# specific rules apply with respect to variable and function references.
# - Numbered variables (parameters to the block) can be referenced with a single
#   dollar sign: $(1), $(2), $(3), etc.
# - pkgdir and pkgname should be referenced with a single dollar sign too. These
#   functions rely on 'the most recently parsed makefile' which is supposed to
#   be the package .mk file. If we defer the evaluation of these functions using
#   double dollar signs, then they may be evaluated too late, when other
#   makefiles have already been parsed. One specific case is when $$(pkgdir) is
#   assigned to a variable using deferred evaluation with '=' and this variable
#   is used in a target rule outside the eval'ed inner block. In this case, the
#   pkgdir will be that of the last makefile parsed by buildroot, which is not
#   the expected value. This mechanism is for example used for the TARGET_PATCH
#   rule.
# - All other variables should be referenced with a double dollar sign:
#   $$(TARGET_DIR), $$($(2)_VERSION), etc. Also all make functions should be
#   referenced with a double dollar sign: $$(subst), $$(call), $$(filter-out),
#   etc. This rule ensures that these variables and functions are only expanded
#   during the $(eval) step, and not earlier. Otherwise, unintuitive and
#   undesired behavior occurs with respect to these variables and functions.
#
################################################################################

define inner-generic-package

# When doing a package, we're definitely not doing a rootfs, but we
# may inherit it via the dependency chain, so we reset it.
$(1): ROOTFS=

# Ensure the package is only declared once, i.e. do not accept that a
# package be re-defined by a br2-external tree
ifneq ($(call strip,$(filter $(1),$(PACKAGES_ALL))),)
$$(error Package '$(1)' defined a second time in '$(pkgdir)'; \
	previous definition was in '$$($(2)_PKGDIR)')
endif
PACKAGES_ALL += $(1)

# Define default values for various package-related variables, if not
# already defined. For some variables (version, source, site and
# subdir), if they are undefined, we try to see if a variable without
# the HOST_ prefix is defined. If so, we use such a variable, so that
# this information has only to be specified once, for both the
# target and host packages of a given .mk file.

$(2)_TYPE                       =  $(4)
$(2)_NAME			=  $(1)
$(2)_RAWNAME			=  $$(patsubst host-%,%,$(1))
$(2)_PKGDIR			=  $(pkgdir)

# Keep the package version that may contain forward slashes in the _DL_VERSION
# variable, then replace all forward slashes ('/') by underscores ('_') to
# sanitize the package version that is used in paths, directory and file names.
# Forward slashes may appear in the package's version when pointing to a
# version control system branch or tag, for example remotes/origin/1_10_stable.
# Similar for spaces and colons (:) that may appear in date-based revisions for
# CVS.
ifndef $(2)_VERSION
 ifdef $(3)_DL_VERSION
  $(2)_DL_VERSION := $$($(3)_DL_VERSION)
 else ifdef $(3)_VERSION
  $(2)_DL_VERSION := $$($(3)_VERSION)
 endif
else
 $(2)_DL_VERSION := $$(strip $$($(2)_VERSION))
endif
$(2)_VERSION := $$(call sanitize,$$($(2)_DL_VERSION))

$(2)_HASH_FILE = \
	$$(strip \
		$$(if $$(wildcard $$($(2)_PKGDIR)/$$($(2)_VERSION)/$$($(2)_RAWNAME).hash),\
			$$($(2)_PKGDIR)/$$($(2)_VERSION)/$$($(2)_RAWNAME).hash,\
			$$($(2)_PKGDIR)/$$($(2)_RAWNAME).hash))

ifdef $(3)_OVERRIDE_SRCDIR
  $(2)_OVERRIDE_SRCDIR ?= $$($(3)_OVERRIDE_SRCDIR)
endif

$(2)_BASENAME	= $$(if $$($(2)_VERSION),$(1)-$$($(2)_VERSION),$(1))
$(2)_BASENAME_RAW = $$(if $$($(2)_VERSION),$$($(2)_RAWNAME)-$$($(2)_VERSION),$$($(2)_RAWNAME))
$(2)_DL_SUBDIR ?= $$($(2)_RAWNAME)
$(2)_DL_DIR = $$(DL_DIR)/$$($(2)_DL_SUBDIR)
$(2)_DIR	=  $$(BUILD_DIR)/$$($(2)_BASENAME)

ifndef $(2)_SUBDIR
 ifdef $(3)_SUBDIR
  $(2)_SUBDIR = $$($(3)_SUBDIR)
 else
  $(2)_SUBDIR ?=
 endif
endif

ifndef $(2)_STRIP_COMPONENTS
 ifdef $(3)_STRIP_COMPONENTS
  $(2)_STRIP_COMPONENTS = $$($(3)_STRIP_COMPONENTS)
 else
  $(2)_STRIP_COMPONENTS ?= 1
 endif
endif

$(2)_SRCDIR		       = $$($(2)_DIR)/$$($(2)_SUBDIR)
$(2)_BUILDDIR		       ?= $$($(2)_SRCDIR)

ifneq ($$($(2)_OVERRIDE_SRCDIR),)
$(2)_VERSION = custom
endif

ifndef $(2)_SOURCE
 ifdef $(3)_SOURCE
  $(2)_SOURCE = $$($(3)_SOURCE)
 else ifdef $(2)_VERSION
  $(2)_SOURCE			?= $$($(2)_BASENAME_RAW).tar.gz
 endif
endif

# If FOO_ACTUAL_SOURCE_TARBALL is explicitly defined, it means FOO_SOURCE is
# indeed a binary (e.g. external toolchain) and FOO_ACTUAL_SOURCE_TARBALL/_SITE
# point to the actual sources tarball. Use the actual sources for legal-info.
# For most packages the FOO_SITE/FOO_SOURCE pair points to real source code,
# so these are the defaults for FOO_ACTUAL_*.
$(2)_ACTUAL_SOURCE_TARBALL ?= $$($(2)_SOURCE)
$(2)_ACTUAL_SOURCE_SITE    ?= $$(call qstrip,$$($(2)_SITE))

ifndef $(2)_PATCH
 ifdef $(3)_PATCH
  $(2)_PATCH = $$($(3)_PATCH)
 endif
endif

$(2)_ALL_DOWNLOADS = \
	$$(if $$($(2)_SOURCE),$$($(2)_SITE_METHOD)+$$($(2)_SITE)/$$($(2)_SOURCE)) \
	$$(foreach p,$$($(2)_PATCH) $$($(2)_EXTRA_DOWNLOADS),\
		$$(if $$(findstring ://,$$(p)),$$(p),\
			$$($(2)_SITE_METHOD)+$$($(2)_SITE)/$$(p)))

ifndef $(2)_SITE
 ifdef $(3)_SITE
  $(2)_SITE = $$($(3)_SITE)
 endif
endif

ifndef $(2)_SITE_METHOD
 ifdef $(3)_SITE_METHOD
  $(2)_SITE_METHOD = $$($(3)_SITE_METHOD)
 else
	# Try automatic detection using the scheme part of the URI
	$(2)_SITE_METHOD = $$(call geturischeme,$$($(2)_SITE))
 endif
endif

ifndef $(2)_DL_OPTS
 ifdef $(3)_DL_OPTS
  $(2)_DL_OPTS = $$($(3)_DL_OPTS)
 endif
endif

ifneq ($$(filter bzr cvs hg svn,$$($(2)_SITE_METHOD)),)
BR_NO_CHECK_HASH_FOR += $$($(2)_SOURCE)
endif

# Do not accept to download git submodule if not using the git method
ifneq ($$($(2)_GIT_SUBMODULES),)
 ifneq ($$($(2)_SITE_METHOD),git)
  $$(error $(2) declares having git sub-modules, but does not use the \
	   'git' method (uses '$$($(2)_SITE_METHOD)' instead))
 endif
endif

ifeq ($$($(2)_SITE_METHOD),local)
ifeq ($$($(2)_OVERRIDE_SRCDIR),)
$(2)_OVERRIDE_SRCDIR = $$($(2)_SITE)
endif
ifeq ($$($(2)_OVERRIDE_SRCDIR),)
$$(error $(1) has local site method, but `$(2)_SITE` is not defined)
endif
endif

ifndef $(2)_LICENSE
 ifdef $(3)_LICENSE
  $(2)_LICENSE = $$($(3)_LICENSE)
 endif
endif

$(2)_LICENSE			?= unknown

ifndef $(2)_LICENSE_FILES
 ifdef $(3)_LICENSE_FILES
  $(2)_LICENSE_FILES = $$($(3)_LICENSE_FILES)
 endif
endif

ifndef $(2)_REDISTRIBUTE
 ifdef $(3)_REDISTRIBUTE
  $(2)_REDISTRIBUTE = $$($(3)_REDISTRIBUTE)
 endif
endif

$(2)_REDISTRIBUTE		?= YES

$(2)_REDIST_SOURCES_DIR = $$(REDIST_SOURCES_DIR_$$(call UPPERCASE,$(4)))/$$($(2)_BASENAME_RAW)

# When a target package is a toolchain dependency set this variable to
# 'NO' so the 'toolchain' dependency is not added to prevent a circular
# dependency.
# Similarly for the skeleton.
$(2)_ADD_TOOLCHAIN_DEPENDENCY	?= YES
$(2)_ADD_SKELETON_DEPENDENCY	?= YES


ifeq ($(4),target)
ifeq ($$($(2)_ADD_SKELETON_DEPENDENCY),YES)
$(2)_DEPENDENCIES += skeleton
endif
ifeq ($$($(2)_ADD_TOOLCHAIN_DEPENDENCY),YES)
$(2)_DEPENDENCIES += toolchain
endif
endif

ifneq ($(1),host-skeleton)
$(2)_DEPENDENCIES += host-skeleton
endif

ifneq ($$(filter cvs git svn,$$($(2)_SITE_METHOD)),)
$(2)_DOWNLOAD_DEPENDENCIES += \
	$(BR2_GZIP_HOST_DEPENDENCY) \
	$(BR2_TAR_HOST_DEPENDENCY)
endif

ifeq ($$(filter host-tar host-skeleton host-fakedate,$(1)),)
$(2)_EXTRACT_DEPENDENCIES += $$(BR2_TAR_HOST_DEPENDENCY)
endif

ifeq ($$(filter host-tar host-skeleton host-xz host-lzip host-fakedate,$(1)),)
$(2)_EXTRACT_DEPENDENCIES += \
	$$(foreach dl,$$($(2)_ALL_DOWNLOADS),\
		$$(call extractor-pkg-dependency,$$(notdir $$(dl))))
endif

ifeq ($$(BR2_CCACHE),y)
ifeq ($$(filter host-tar host-skeleton host-xz host-lzip host-fakedate host-ccache,$(1)),)
$(2)_DEPENDENCIES += host-ccache
endif
endif

ifeq ($$(BR2_REPRODUCIBLE),y)
ifeq ($$(filter host-skeleton host-fakedate,$(1)),)
$(2)_DEPENDENCIES += host-fakedate
endif
endif

# Eliminate duplicates in dependencies
$(2)_FINAL_DEPENDENCIES = $$(sort $$($(2)_DEPENDENCIES))
$(2)_FINAL_DOWNLOAD_DEPENDENCIES = $$(sort $$($(2)_DOWNLOAD_DEPENDENCIES))
$(2)_FINAL_EXTRACT_DEPENDENCIES = $$(sort $$($(2)_EXTRACT_DEPENDENCIES))
$(2)_FINAL_PATCH_DEPENDENCIES = $$(sort $$($(2)_PATCH_DEPENDENCIES))
$(2)_FINAL_ALL_DEPENDENCIES = \
	$$(sort \
		$$($(2)_FINAL_DEPENDENCIES) \
		$$($(2)_FINAL_DOWNLOAD_DEPENDENCIES) \
		$$($(2)_FINAL_EXTRACT_DEPENDENCIES) \
		$$($(2)_FINAL_PATCH_DEPENDENCIES))
$(2)_FINAL_RECURSIVE_DEPENDENCIES = $$(sort \
	$$(if $$(filter undefined,$$(origin $(2)_FINAL_RECURSIVE_DEPENDENCIES__X)), \
		$$(eval $(2)_FINAL_RECURSIVE_DEPENDENCIES__X := \
			$$(foreach p, \
				$$($(2)_FINAL_ALL_DEPENDENCIES), \
				$$(p) \
				$$($$(call UPPERCASE,$$(p))_FINAL_RECURSIVE_DEPENDENCIES) \
			) \
		) \
	) \
	$$($(2)_FINAL_RECURSIVE_DEPENDENCIES__X))

$(2)_FINAL_RECURSIVE_RDEPENDENCIES = $$(sort \
	$$(if $$(filter undefined,$$(origin $(2)_FINAL_RECURSIVE_RDEPENDENCIES__X)), \
		$$(eval $(2)_FINAL_RECURSIVE_RDEPENDENCIES__X := \
			$$(foreach p, \
				$$($(2)_RDEPENDENCIES), \
				$$(p) \
				$$($$(call UPPERCASE,$$(p))_FINAL_RECURSIVE_RDEPENDENCIES) \
			) \
		) \
	) \
	$$($(2)_FINAL_RECURSIVE_RDEPENDENCIES__X))

$(2)_INSTALL_STAGING		?= NO
$(2)_INSTALL_IMAGES		?= NO
$(2)_INSTALL_TARGET		?= YES

# define sub-target stamps
$(2)_TARGET_INSTALL_TARGET =	$$($(2)_DIR)/.stamp_target_installed
$(2)_TARGET_INSTALL_STAGING =	$$($(2)_DIR)/.stamp_staging_installed
$(2)_TARGET_INSTALL_IMAGES =	$$($(2)_DIR)/.stamp_images_installed
$(2)_TARGET_INSTALL_HOST =	$$($(2)_DIR)/.stamp_host_installed
$(2)_TARGET_BUILD =		$$($(2)_DIR)/.stamp_built
$(2)_TARGET_CONFIGURE =		$$($(2)_DIR)/.stamp_configured
$(2)_TARGET_RSYNC =		$$($(2)_DIR)/.stamp_rsynced
$(2)_TARGET_PATCH =		$$($(2)_DIR)/.stamp_patched
$(2)_TARGET_EXTRACT =		$$($(2)_DIR)/.stamp_extracted
$(2)_TARGET_SOURCE =		$$($(2)_DIR)/.stamp_downloaded
$(2)_TARGET_ACTUAL_SOURCE =	$$($(2)_DIR)/.stamp_actual_downloaded
$(2)_TARGET_DIRCLEAN =		$$($(2)_DIR)/.stamp_dircleaned

# default extract command
$(2)_EXTRACT_CMDS ?= \
	$$(if $$($(2)_SOURCE),$$(INFLATE$$(suffix $$($(2)_SOURCE))) $$($(2)_DL_DIR)/$$($(2)_SOURCE) | \
	$$(TAR) --strip-components=$$($(2)_STRIP_COMPONENTS) \
		-C $$($(2)_DIR) \
		$$(foreach x,$$($(2)_EXCLUDES),--exclude='$$(x)' ) \
		$$(TAR_OPTIONS) -)

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
$(2)_TARGET_FINALIZE_HOOKS      ?=
$(2)_ROOTFS_PRE_CMD_HOOKS       ?=

ifeq ($$($(2)_TYPE),target)
ifneq ($$(HOST_$(2)_KCONFIG_VAR),)
$$(error "Package $(1) defines host variant before target variant!")
endif
endif

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

$(1)-install-host:		$$($(2)_TARGET_INSTALL_HOST)
$$($(2)_TARGET_INSTALL_HOST):	$$($(2)_TARGET_BUILD)

$(1)-build:		$$($(2)_TARGET_BUILD)
$$($(2)_TARGET_BUILD):	$$($(2)_TARGET_CONFIGURE)

# Since $(2)_FINAL_DEPENDENCIES are phony targets, they are always "newer"
# than $(2)_TARGET_CONFIGURE. This would force the configure step (and
# therefore the other steps as well) to be re-executed with every
# invocation of make.  Therefore, make $(2)_FINAL_DEPENDENCIES an order-only
# dependency by using |.

$(1)-configure:			$$($(2)_TARGET_CONFIGURE)
$$($(2)_TARGET_CONFIGURE):	| $$($(2)_FINAL_DEPENDENCIES)

$$($(2)_TARGET_SOURCE) $$($(2)_TARGET_RSYNC): | prepare
$$($(2)_TARGET_SOURCE) $$($(2)_TARGET_RSYNC): | dependencies

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
# Order-only dependency
$$($(2)_TARGET_PATCH):  | $$(patsubst %,%-patch,$$($(2)_FINAL_PATCH_DEPENDENCIES))

$(1)-extract:			$$($(2)_TARGET_EXTRACT)
$$($(2)_TARGET_EXTRACT):	$$($(2)_TARGET_SOURCE)
$$($(2)_TARGET_EXTRACT): | $$($(2)_FINAL_EXTRACT_DEPENDENCIES)

$(1)-depends:		$$($(2)_FINAL_ALL_DEPENDENCIES)

$(1)-source:		$$($(2)_TARGET_SOURCE)
$$($(2)_TARGET_SOURCE): | $$($(2)_FINAL_DOWNLOAD_DEPENDENCIES)

$(1)-all-source:	$(1)-legal-source
$(1)-legal-info:	$(1)-legal-source
$(1)-legal-source:	$(1)-source

# Only download the actual source if it differs from the 'main' archive
ifneq ($$($(2)_ACTUAL_SOURCE_TARBALL),)
ifneq ($$($(2)_ACTUAL_SOURCE_TARBALL),$$($(2)_SOURCE))
$(1)-legal-source:	$$($(2)_TARGET_ACTUAL_SOURCE)
endif # actual sources != sources
endif # actual sources != ""

$(1)-external-deps:
	@for p in $$($(2)_SOURCE) $$($(2)_PATCH) $$($(2)_EXTRA_DOWNLOADS) ; do \
		echo `basename $$$$p` ; \
	done
else
# In the package override case, the sequence of steps
#  source, by rsyncing
#  depends
#  configure

# Use an order-only dependency so the "<pkg>-clean-for-rebuild" rule
# can remove the stamp file without triggering the configure step.
$$($(2)_TARGET_CONFIGURE): | $$($(2)_TARGET_RSYNC)

$(1)-depends:		$$($(2)_FINAL_DEPENDENCIES)

$(1)-patch:		$(1)-rsync
$(1)-extract:		$(1)-rsync

$(1)-rsync:		$$($(2)_TARGET_RSYNC)

$(1)-source:
$(1)-legal-source:

$(1)-external-deps:
	@echo "file://$$($(2)_OVERRIDE_SRCDIR)"
endif

$(1)-show-version:
			@echo $$($(2)_VERSION)

$(1)-show-depends:
			@echo $$($(2)_FINAL_ALL_DEPENDENCIES)

$(1)-show-recursive-depends:
			@echo $$($(2)_FINAL_RECURSIVE_DEPENDENCIES)

$(1)-show-rdepends:
			@echo $$($(2)_RDEPENDENCIES)

$(1)-show-recursive-rdepends:
			@echo $$($(2)_FINAL_RECURSIVE_RDEPENDENCIES)

$(1)-show-build-order: $$(patsubst %,%-show-build-order,$$($(2)_FINAL_ALL_DEPENDENCIES))
	@:
	$$(info $(1))

$(1)-show-info:
	@:
	$$(info $$(call clean-json,{ $$(call json-info,$(2)) }))

$(1)-graph-depends: graph-depends-requirements
	$(call pkg-graph-depends,$(1),--direct)

$(1)-graph-rdepends: graph-depends-requirements
	$(call pkg-graph-depends,$(1),--reverse)

$(1)-all-source:	$(1)-source
$(1)-all-source:	$$(foreach p,$$($(2)_FINAL_ALL_DEPENDENCIES),$$(p)-all-source)

$(1)-all-external-deps:	$(1)-external-deps
$(1)-all-external-deps:	$$(foreach p,$$($(2)_FINAL_ALL_DEPENDENCIES),$$(p)-all-external-deps)

$(1)-all-legal-info:	$(1)-legal-info
$(1)-all-legal-info:	$$(foreach p,$$($(2)_FINAL_ALL_DEPENDENCIES),$$(p)-all-legal-info)

$(1)-dirclean:		$$($(2)_TARGET_DIRCLEAN)

$(1)-clean-for-reinstall:
ifneq ($$($(2)_OVERRIDE_SRCDIR),)
			rm -f $$($(2)_TARGET_RSYNC)
endif
			rm -f $$($(2)_TARGET_INSTALL_STAGING)
			rm -f $$($(2)_TARGET_INSTALL_TARGET)
			rm -f $$($(2)_TARGET_INSTALL_IMAGES)
			rm -f $$($(2)_TARGET_INSTALL_HOST)

$(1)-reinstall:		$(1)-clean-for-reinstall $(1)

$(1)-clean-for-rebuild: $(1)-clean-for-reinstall
			rm -f $$($(2)_TARGET_BUILD)

$(1)-rebuild:		$(1)-clean-for-rebuild $(1)

$(1)-clean-for-reconfigure: $(1)-clean-for-rebuild
			rm -f $$($(2)_TARGET_CONFIGURE)

$(1)-reconfigure:	$(1)-clean-for-reconfigure $(1)

# define the PKG variable for all targets, containing the
# uppercase package variable prefix
$$($(2)_TARGET_INSTALL_TARGET):		PKG=$(2)
$$($(2)_TARGET_INSTALL_STAGING):	PKG=$(2)
$$($(2)_TARGET_INSTALL_IMAGES):		PKG=$(2)
$$($(2)_TARGET_INSTALL_HOST):		PKG=$(2)
$$($(2)_TARGET_BUILD):			PKG=$(2)
$$($(2)_TARGET_CONFIGURE):		PKG=$(2)
$$($(2)_TARGET_CONFIGURE):		NAME=$(1)
$$($(2)_TARGET_RSYNC):			SRCDIR=$$($(2)_OVERRIDE_SRCDIR)
$$($(2)_TARGET_RSYNC):			PKG=$(2)
$$($(2)_TARGET_PATCH):			PKG=$(2)
$$($(2)_TARGET_PATCH):			RAWNAME=$$(patsubst host-%,%,$(1))
$$($(2)_TARGET_PATCH):			PKGDIR=$(pkgdir)
$$($(2)_TARGET_EXTRACT):		PKG=$(2)
$$($(2)_TARGET_SOURCE):			PKG=$(2)
$$($(2)_TARGET_SOURCE):			PKGDIR=$(pkgdir)
$$($(2)_TARGET_ACTUAL_SOURCE):		PKG=$(2)
$$($(2)_TARGET_ACTUAL_SOURCE):		PKGDIR=$(pkgdir)
$$($(2)_TARGET_DIRCLEAN):		PKG=$(2)
$$($(2)_TARGET_DIRCLEAN):		NAME=$(1)

# Compute the name of the Kconfig option that correspond to the
# package being enabled. We handle three cases: the special Linux
# kernel case, the bootloaders case, and the normal packages case.
ifeq ($(1),linux)
$(2)_KCONFIG_VAR = BR2_LINUX_KERNEL
else ifneq ($$(filter boot/% $$(foreach dir,$$(BR2_EXTERNAL_DIRS),$$(dir)/boot/%),$(pkgdir)),)
$(2)_KCONFIG_VAR = BR2_TARGET_$(2)
else ifneq ($$(filter toolchain/% $$(foreach dir,$$(BR2_EXTERNAL_DIRS),$$(dir)/toolchain/%),$(pkgdir)),)
$(2)_KCONFIG_VAR = BR2_$(2)
else
$(2)_KCONFIG_VAR = BR2_PACKAGE_$(2)
endif

# legal-info: declare dependencies and set values used later for the manifest
ifneq ($$($(2)_LICENSE_FILES),)
$(2)_MANIFEST_LICENSE_FILES = $$($(2)_LICENSE_FILES)
endif

# We need to extract and patch a package to be able to retrieve its
# license files (if any) and the list of patches applied to it (if
# any).
$(1)-legal-info: $(1)-patch

# We only save the sources of packages we want to redistribute, that are
# non-overriden (local or true override).
ifeq ($$($(2)_REDISTRIBUTE),YES)
ifeq ($$($(2)_OVERRIDE_SRCDIR),)
# Packages that have a tarball need it downloaded beforehand
$(1)-legal-info: $(1)-source $$(REDIST_SOURCES_DIR_$$(call UPPERCASE,$(4)))
endif
endif

# legal-info: produce legally relevant info.
$(1)-legal-info: PKG=$(2)
$(1)-legal-info:
	@$$(call MESSAGE,"Collecting legal info")
# Packages without a source are assumed to be part of Buildroot, skip them.
	$$(foreach hook,$$($(2)_PRE_LEGAL_INFO_HOOKS),$$(call $$(hook))$$(sep))
ifneq ($$(call qstrip,$$($(2)_SOURCE)),)

# Save license files if defined
# We save the license files for any kind of package: normal, local,
# overridden, or non-redistributable alike.
# The reason to save license files even for no-redistribute packages
# is that the license still applies to the files distributed as part
# of the rootfs, even if the sources are not themselves redistributed.
ifeq ($$(call qstrip,$$($(2)_LICENSE_FILES)),)
	$(Q)$$(call legal-warning-pkg,$$($(2)_BASENAME_RAW),cannot save license ($(2)_LICENSE_FILES not defined))
else
	$(Q)$$(foreach F,$$($(2)_LICENSE_FILES),$$(call legal-license-file,$$($(2)_RAWNAME),$$($(2)_BASENAME_RAW),$$($(2)_HASH_FILE),$$(F),$$($(2)_DIR)/$$(F),$$(call UPPERCASE,$(4)))$$(sep))
endif # license files

ifeq ($$($(2)_SITE_METHOD),local)
# Packages without a tarball: don't save and warn
	@$$(call legal-warning-nosource,$$($(2)_RAWNAME),local)

else ifneq ($$($(2)_OVERRIDE_SRCDIR),)
	@$$(call legal-warning-nosource,$$($(2)_RAWNAME),override)

else
# Other packages

ifeq ($$($(2)_REDISTRIBUTE),YES)
# Save the source tarball and any extra downloads, but not
# patches, as they are handled specially afterwards.
	$$(foreach e,$$($(2)_ACTUAL_SOURCE_TARBALL) $$(notdir $$($(2)_EXTRA_DOWNLOADS)),\
		$$(Q)support/scripts/hardlink-or-copy \
			$$($(2)_DL_DIR)/$$(e) \
			$$($(2)_REDIST_SOURCES_DIR)$$(sep))
# Save patches and generate the series file
	$$(Q)while read f; do \
		support/scripts/hardlink-or-copy \
			$$$${f} \
			$$($(2)_REDIST_SOURCES_DIR) || exit 1; \
		printf "%s\n" "$$$${f##*/}" >>$$($(2)_REDIST_SOURCES_DIR)/series || exit 1; \
	done <$$($(2)_DIR)/.applied_patches_list
endif # redistribute

endif # other packages
	@$$(call legal-manifest,$$(call UPPERCASE,$(4)),$$($(2)_RAWNAME),$$($(2)_VERSION),$$(subst $$(space)$$(comma),$$(comma),$$($(2)_LICENSE)),$$($(2)_MANIFEST_LICENSE_FILES),$$($(2)_ACTUAL_SOURCE_TARBALL),$$($(2)_ACTUAL_SOURCE_SITE),$$(call legal-deps,$(1)))
endif # ifneq ($$(call qstrip,$$($(2)_SOURCE)),)
	$$(foreach hook,$$($(2)_POST_LEGAL_INFO_HOOKS),$$(call $$(hook))$$(sep))

# add package to the general list of targets if requested by the buildroot
# configuration
ifeq ($$($$($(2)_KCONFIG_VAR)),y)

# Ensure the calling package is the declared provider for all the virtual
# packages it claims to be an implementation of.
ifneq ($$($(2)_PROVIDES),)
$$(foreach pkg,$$($(2)_PROVIDES),\
	$$(eval $$(call virt-provides-single,$$(pkg),$$(call UPPERCASE,$$(pkg)),$(1))$$(sep)))
endif

# Register package as a reverse-dependencies of all its dependencies
$$(eval $$(foreach p,$$($(2)_FINAL_ALL_DEPENDENCIES),\
	$$(call UPPERCASE,$$(p))_RDEPENDENCIES += $(1)$$(sep)))

# Ensure unified variable name conventions between all packages Some
# of the variables are used by more than one infrastructure; so,
# rather than duplicating the checks in each infrastructure, we check
# all variables here in pkg-generic, even though pkg-generic should
# have no knowledge of infra-specific variables.
$(eval $(call check-deprecated-variable,$(2)_MAKE_OPT,$(2)_MAKE_OPTS))
$(eval $(call check-deprecated-variable,$(2)_INSTALL_OPT,$(2)_INSTALL_OPTS))
$(eval $(call check-deprecated-variable,$(2)_INSTALL_TARGET_OPT,$(2)_INSTALL_TARGET_OPTS))
$(eval $(call check-deprecated-variable,$(2)_INSTALL_STAGING_OPT,$(2)_INSTALL_STAGING_OPTS))
$(eval $(call check-deprecated-variable,$(2)_INSTALL_HOST_OPT,$(2)_INSTALL_HOST_OPTS))
$(eval $(call check-deprecated-variable,$(2)_AUTORECONF_OPT,$(2)_AUTORECONF_OPTS))
$(eval $(call check-deprecated-variable,$(2)_CONF_OPT,$(2)_CONF_OPTS))
$(eval $(call check-deprecated-variable,$(2)_BUILD_OPT,$(2)_BUILD_OPTS))
$(eval $(call check-deprecated-variable,$(2)_GETTEXTIZE_OPT,$(2)_GETTEXTIZE_OPTS))
$(eval $(call check-deprecated-variable,$(2)_KCONFIG_OPT,$(2)_KCONFIG_OPTS))

PACKAGES += $(1)

ifneq ($$($(2)_PERMISSIONS),)
PACKAGES_PERMISSIONS_TABLE += $$($(2)_PERMISSIONS)$$(sep)
endif
ifneq ($$($(2)_DEVICES),)
PACKAGES_DEVICES_TABLE += $$($(2)_DEVICES)$$(sep)
endif
ifneq ($$($(2)_USERS),)
PACKAGES_USERS += $$($(2)_USERS)$$(sep)
endif
TARGET_FINALIZE_HOOKS += $$($(2)_TARGET_FINALIZE_HOOKS)
ROOTFS_PRE_CMD_HOOKS += $$($(2)_ROOTFS_PRE_CMD_HOOKS)
KEEP_PYTHON_PY_FILES += $$($(2)_KEEP_PY_FILES)

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

DL_TOOLS_DEPENDENCIES += $$(call extractor-system-dependency,$$($(2)_SOURCE))

# Ensure all virtual targets are PHONY. Listed alphabetically.
.PHONY:	$(1) \
	$(1)-all-external-deps \
	$(1)-all-legal-info \
	$(1)-all-source \
	$(1)-build \
	$(1)-clean-for-rebuild \
	$(1)-clean-for-reconfigure \
	$(1)-clean-for-reinstall \
	$(1)-configure \
	$(1)-depends \
	$(1)-dirclean \
	$(1)-external-deps \
	$(1)-extract \
	$(1)-graph-depends \
	$(1)-graph-rdepends \
	$(1)-install \
	$(1)-install-host \
	$(1)-install-images \
	$(1)-install-staging \
	$(1)-install-target \
	$(1)-legal-info \
	$(1)-legal-source \
	$(1)-patch \
	$(1)-rebuild \
	$(1)-reconfigure \
	$(1)-reinstall \
	$(1)-rsync \
	$(1)-show-depends \
	$(1)-show-info \
	$(1)-show-version \
	$(1)-source

ifneq ($$($(2)_SOURCE),)
ifeq ($$($(2)_SITE),)
$$(error $(2)_SITE cannot be empty when $(2)_SOURCE is not)
endif
endif

ifeq ($$(patsubst %/,ERROR,$$($(2)_SITE)),ERROR)
$$(error $(2)_SITE ($$($(2)_SITE)) cannot have a trailing slash)
endif

ifneq ($$($(2)_HELP_CMDS),)
HELP_PACKAGES += $(2)
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
