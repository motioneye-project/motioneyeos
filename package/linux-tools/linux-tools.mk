################################################################################
#
# linux-tools
#
################################################################################

# Vampirising sources from the kernel tree, so no source nor site specified.
# Instead, we directly build in the sources of the linux package. We can do
# that, because we're not building in the same location and the same files.
#
# So, all tools refer to $(LINUX_DIR) instead of $(@D).

# We only need the kernel to be extracted, not actually built
LINUX_TOOLS_PATCH_DEPENDENCIES = linux

# Install Linux kernel tools in the staging directory since some tools
# may install shared libraries and headers (e.g. cpupower).
LINUX_TOOLS_INSTALL_STAGING = YES

# Include all our tools definitions.
#
# Note: our package infrastructure uses the full-path of the last-scanned
# Makefile to determine what package we're currently defining, using the
# last directory component in the path. As such, including other Makefile,
# like below, before we call one of the *-package macro is usally not
# working.
# However, since the files we include here are in the same directory as
# the current Makefile, we are OK. But this is a hard requirement: files
# included here *must* be in the same directory!
include $(sort $(wildcard package/linux-tools/linux-tool-*.mk))

LINUX_TOOLS_DEPENDENCIES += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
		$($(call UPPERCASE,$(tool))_DEPENDENCIES)))

LINUX_TOOLS_POST_BUILD_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_BUILD_CMDS))

LINUX_TOOLS_POST_INSTALL_STAGING_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_INSTALL_STAGING_CMDS))

LINUX_TOOLS_POST_INSTALL_TARGET_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
	$(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
		$(call UPPERCASE,$(tool))_INSTALL_TARGET_CMDS))

$(eval $(generic-package))
