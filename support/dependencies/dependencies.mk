################################################################################
#
# Check buildroot dependencies and bail out if the user's
# system is judged to be lacking....
#
################################################################################

ifeq ($(BR2_FORCE_HOST_BUILD),y)
# ignore all available host packages
define suitable-host-package
endef
else
# suitable-host-pkg: calls check-host-$(1).sh shell script. Parameter (2)
# can be the candidate to be checked. If not present, the check-host-$(1).sh
# script should use 'which' to find a candidate. The script should return
# the path to the suitable host tool, or nothing if no suitable tool was found.
define suitable-host-package
$(shell support/dependencies/check-host-$(1).sh $(2))
endef
endif
# host utilities needs host-tar to extract the source code tarballs, so
# ensure check-host-tar.mk is included before the rest
include support/dependencies/check-host-tar.mk
-include $(sort $(filter-out %-tar.mk,$(wildcard support/dependencies/check-host-*.mk)))

dependencies:
	@MAKE="$(MAKE)" DL_TOOLS="$(sort $(DL_TOOLS_DEPENDENCIES))" \
		$(TOPDIR)/support/dependencies/dependencies.sh

################################################################################
#
# Toplevel Makefile options
#
################################################################################
.PHONY: dependencies
