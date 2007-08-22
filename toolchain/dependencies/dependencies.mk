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
ifneq ($(findstring y,$(BR2_KERNEL_HEADERS_LZMA)),)
DEPENDENCIES_HOST_PREREQ+=host-lzma
endif

dependencies: host-sed $(DEPENDENCIES_HOST_PREREQ)
	@HOSTCC="$(firstword $(HOSTCC))" MAKE="$(MAKE)" \
		HOST_SED_DIR="$(HOST_SED_DIR)" \
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

