#############################################################
#
# build makedevs to run on the build system, in order to create
# device nodes and whatnot for the target device, in conjunction
# with fakeroot.
#
#############################################################
MAKEDEVS_DIR=$(BUILD_DIR)/makedevs-host

$(MAKEDEVS_DIR)/makedevs.c: target/makedevs/makedevs.c
	rm -rf $(MAKEDEVS_DIR)
	mkdir $(MAKEDEVS_DIR)
	cp target/makedevs/makedevs.c $(MAKEDEVS_DIR)

$(MAKEDEVS_DIR)/makedevs: $(MAKEDEVS_DIR)/makedevs.c
	$(HOSTCC) -Wall -Werror -O2 $(MAKEDEVS_DIR)/makedevs.c -o $@

$(HOST_DIR)/usr/bin/makedevs: $(MAKEDEVS_DIR)/makedevs
	$(INSTALL) -m 755 $^ $@

makedevs: $(HOST_DIR)/usr/bin/makedevs

makedevs-source:

makedevs-clean:
	rm -rf $(MAKEDEVS_DIR)/makedevs

makedevs-dirclean:
	rm -rf $(MAKEDEVS_DIR)

