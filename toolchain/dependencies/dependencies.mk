######################################################################
#
# Check buildroot dependencies and bail out if the user's
# system is judged to be lacking....
#
######################################################################

DEPENDENCIES_HOST_PREREQ:=
ifeq ($(BR2_STRIP_sstrip),y)
DEPENDENCIES_HOST_PREREQ+=host-sstrip
endif

# Remove duplicate entries from $(DL_TOOLS_DEPENDENCIES)
DL_TOOLS = \
	$(findstring svn,$(DL_TOOLS_DEPENDENCIES)) \
	$(findstring git,$(DL_TOOLS_DEPENDENCIES)) \
	$(findstring bzr,$(DL_TOOLS_DEPENDENCIES))

dependencies: $(DEPENDENCIES_HOST_PREREQ)
	@HOSTCC="$(firstword $(HOSTCC))" MAKE="$(MAKE)" \
		CONFIG_FILE="$(CONFIG_DIR)/.config" \
		DL_TOOLS="$(DL_TOOLS)" \
		$(TOPDIR)/toolchain/dependencies/dependencies.sh

dependencies-source:

dependencies-clean:
	rm -f $(SSTRIP_TARGET)

dependencies-dirclean:
	true

#############################################################
#
# Toplevel Makefile options
#
#############################################################
.PHONY: dependencies

