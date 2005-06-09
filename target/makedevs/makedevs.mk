#############################################################
#
# build makedevs to run on the build system, in order to create
# device nodes and whatnot for the target device, in conjunction
# with fakeroot.
#
#############################################################
MAKEDEVS_DIR=$(BUILD_DIR)/makedevs

$(MAKEDEVS_DIR)/makedevs.c:
	mkdir $(MAKEDEVS_DIR)
	cp target/makedevs/makedevs.c $(MAKEDEVS_DIR)

$(MAKEDEVS_DIR)/makedevs: $(MAKEDEVS_DIR)
	gcc -Wall -O2 makedevs.c -o makedevs
	touch -c $(MAKEDEVS_DIR)/makedevs

makedevs: $(MAKEDEVS_DIR)/makedevs

makedevs-source:

makedevs-clean:
	-rm -rf $(MAKEDEVS_DIR)

makedevs-dirclean:
	rm -rf $(MAKEDEVS_DIR)

