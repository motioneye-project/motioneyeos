######################################################################
#
# Check buildroot dependencies and bail out if the user's
# system is judged to be lacking....
#
######################################################################

DEPENDENCIES_HOST_PREREQ:=
ifeq ($(BR2_STRIP_sstrip),y)
DEPENDENCIES_HOST_PREREQ+=sstrip_host
endif

dependencies: $(DEPENDENCIES_HOST_PREREQ)
	@HOSTCC="$(firstword $(HOSTCC))" MAKE="$(MAKE)" \
		CONFIG_FILE="$(CONFIG_DIR)/.config" \
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

