#############################################################
#
# microperl
#
#############################################################
MICROPERL_MAJ=5
MICROPERL_VERSION=$(MICROPERL_MAJ).8.8
MICROPERL_SOURCE=perl-$(MICROPERL_VERSION).tar.bz2
MICROPERL_CAT:=$(BZCAT)
MICROPERL_SITE=ftp://ftp.cpan.org/pub/CPAN/src/5.0
MICROPERL_DIR=$(BUILD_DIR)/perl-$(MICROPERL_VERSION)

MICROPERL_MODS_DIR=/usr/lib/perl$(MICROPERL_MAJ)/$(MICROPERL_VERSION)
MICROPERL_MODS=$(call qstrip,$(BR2_PACKAGE_MICROPERL_MODULES))
ifeq ($(BR2_PACKAGE_AUTOMAKE),y)
MICROPERL_MODS+=File/Basename.pm Errno.pm Config.pm IO/File.pm Symbol.pm \
	SelectSaver.pm IO/Seekable.pm IO/Handle.pm IO.pm XSLoader.pm \
	DynaLoader.pm AutoLoader.pm Carp/Heavy.pm
endif
$(DL_DIR)/$(MICROPERL_SOURCE):
	$(call DOWNLOAD,$(MICROPERL_SITE),$(MICROPERL_SOURCE))

$(MICROPERL_DIR)/.source: $(DL_DIR)/$(MICROPERL_SOURCE)
	$(MICROPERL_CAT) $(DL_DIR)/$(MICROPERL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# makedepend contains bashisms
	$(SED) 's~sh ./makedepend~bash ./makedepend~' \
		$(MICROPERL_DIR)/Makefile.SH \
		$(MICROPERL_DIR)/x2p/Makefile.SH \
		$(MICROPERL_DIR)/pod/Makefile.SH
	chmod -R u+w $(MICROPERL_DIR)
	touch $@

$(MICROPERL_DIR)/.host_configured: $(MICROPERL_DIR)/.source
	# we need to build a perl for the host just for Errno.pm
	(cd $(MICROPERL_DIR); ./Configure -Dcc="$(HOSTCC)" -de  )
	touch $@


$(MICROPERL_DIR)/.host_configured_and_fixed: $(MICROPERL_DIR)/.host_configured
	$(SED) 's/^.*<command-line>.*//g' $(MICROPERL_DIR)/Makefile
	$(SED) 's/^.*<command-line>.*//g' $(MICROPERL_DIR)/x2p/Makefile
	$(SED) 's/^.*<command-line>.*//g' $(MICROPERL_DIR)/makefile
	$(SED) 's/^.*<command-line>.*//g' $(MICROPERL_DIR)/x2p/makefile
	touch $@

$(MICROPERL_DIR)/.host_make: $(MICROPERL_DIR)/.host_configured_and_fixed
	$(MAKE) -C $(MICROPERL_DIR)		|| echo "An error is expected on make"
	touch $@

$(MICROPERL_DIR)/.host_make_fixed: $(MICROPERL_DIR)/.host_make
	$(MAKE) -C $(MICROPERL_DIR) test	|| echo "An error is expected on make test"
	touch $@

$(MICROPERL_DIR)/.configured: $(MICROPERL_DIR)/.host_make_fixed
	# we need to build a perl for the host just for Errno.pm
	(cd $(MICROPERL_DIR); \
	 chmod a+x ext/util/make_ext; \
	 ext/util/make_ext nonxs Errno MAKE="$(firstword $(MAKE))" \
	)
	(cd $(MICROPERL_DIR); \
	 chmod u+w uconfig.h; ./uconfig.sh; \
	 $(MAKE) -f $(MICROPERL_DIR)/Makefile.micro regen_uconfig; \
	 $(SED) 's,PRIVLIB ".*,PRIVLIB "/$(MICROPERL_MODS_DIR)",' \
		 -e 's,PRIVLIB_EXP ".*,PRIVLIB_EXP "$(MICROPERL_MODS_DIR)",' \
		 -e 's,BIN ".*,BIN "/usr/bin",' \
		 ./uconfig.h; \
	)
	touch $@

$(MICROPERL_DIR)/microperl: $(MICROPERL_DIR)/.configured
	$(MAKE) -f $(MICROPERL_DIR)/Makefile.micro CC="$(TARGET_CC)" \
		OPTIMIZE="$(TARGET_CFLAGS)" -C $(MICROPERL_DIR)
ifeq ($(BR2_PACKAGE_AUTOMAKE),y)
	#(cd $(@D); \
	# CONFIG=uconfig.h $(SHELL) ext/util/make_ext nonxs Errno MAKE="$(firstword $(MAKE))"; \
	#)
endif

$(TARGET_DIR)/usr/bin/microperl: $(MICROPERL_DIR)/microperl
ifneq ($(MICROPERL_MODS),)
	(cd $(MICROPERL_DIR); \
	 for i in $(patsubst %,$(TARGET_DIR)/$(MICROPERL_MODS_DIR)/%,$(dir $(MICROPERL_MODS))); do \
		[ -d $$i ] || mkdir -p $$i; \
	 done; \
	 for i in $(MICROPERL_MODS); do \
	 cp -dpf $(MICROPERL_DIR)/lib/$$i $(TARGET_DIR)/$(MICROPERL_MODS_DIR)/$$i; \
	 done; \
	)
endif
	cp -dpf $(MICROPERL_DIR)/microperl $@
ifneq ($(BR2_STRIP_none),y)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $@
endif
	(cd $(TARGET_DIR)/usr/bin; rm -f perl; ln -s microperl perl;)

microperl: $(TARGET_DIR)/usr/bin/microperl

microperl-source: $(DL_DIR)/$(MICROPERL_SOURCE)

microperl-unpacked: $(MICROPERL_DIR)/.source

microperl-config: $(MICROPERL_DIR)/.host_configured

microperl-host: $(MICROPERL_DIR)/.host_make

microperl-host-fixed: $(MICROPERL_DIR)/.host_make_fixed

microperl-clean:
	rm -rf $(TARGET_DIR)/usr/bin/microperl \
		$(TARGET_DIR)/$(MICROPERL_MODS_DIR) $(TARGET_DIR)/usr/bin/perl
	-rmdir $(TARGET_DIR)/usr/lib/perl$(MICROPERL_MAJ)
	-$(MAKE) -C $(MICROPERL_DIR) -f Makefile.micro clean

microperl-dirclean:
	rm -rf $(MICROPERL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_MICROPERL),y)
TARGETS+=microperl
endif
