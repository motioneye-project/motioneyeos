######################################################################
#
# Check buildroot dependencies and bail out if the user's
# system is judged to be lacking....
#
######################################################################

ifeq ($(BR2_STRIP_sstrip),y)
# XXX: this is a little bit ugly, yep.
MAYBE_SSTRIP_HOST:=sstrip_host
endif
dependencies: host-sed host-lzma $(MAYBE_SSTRIP_HOST)
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

