################################################################################
#
# Check buildroot dependencies and bail out if the user's
# system is judged to be lacking....
#
################################################################################

# suitable-host-pkg: calls check-host-$(1).sh shell script. Parameter (2)
# can be the candidate to be checked. If not present, the check-host-$(1).sh
# script should use 'which' to find a candidate. The script should return
# the path to the suitable host tool, or nothing if no suitable tool was found.
define suitable-host-package
$(shell support/dependencies/check-host-$(1).sh $(2))
endef
# host utilities needs host-tar to extract the source code tarballs, so
# ensure check-host-tar.mk is included before the rest
include support/dependencies/check-host-tar.mk
-include $(sort $(filter-out %-tar.mk,$(wildcard support/dependencies/check-host-*.mk)))

ifeq ($(BR2_CCACHE),y)
DEPENDENCIES_HOST_PREREQ += host-ccache
endif

core-dependencies:
	@MAKE="$(MAKE)" DL_TOOLS="$(sort $(DL_TOOLS_DEPENDENCIES))" \
		$(TOPDIR)/support/dependencies/dependencies.sh

$(DEPENDENCIES_HOST_PREREQ): HOSTCC=$(HOSTCC_NOCCACHE)
$(DEPENDENCIES_HOST_PREREQ): HOSTCXX=$(HOSTCXX_NOCCACHE)
$(DEPENDENCIES_HOST_PREREQ): core-dependencies

dependencies: core-dependencies $(DEPENDENCIES_HOST_PREREQ)

################################################################################
#
# Toplevel Makefile options
#
################################################################################
.PHONY: dependencies core-dependencies
