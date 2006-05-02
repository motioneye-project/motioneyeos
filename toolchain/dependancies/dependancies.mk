######################################################################
#
# Check buildroot dependancies and bail out if the user's
# system is judged to be lacking....
#
######################################################################

dependancies:
	$(TOPDIR)/toolchain/dependancies/dependancies.sh

dependancies-source:

dependancies-clean:
	rm -f $(SSTRIP_TARGET)

dependancies-dirclean:
	true

#############################################################
#
# Toplevel Makefile options
#
#############################################################
# unconditionally include this one...
TARGETS+=dependancies
