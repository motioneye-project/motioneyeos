#############################################################
#
# microperl
#
#############################################################
MICROPERL_MAJ=5
MICROPERL_VER=$(MICROPERL_MAJ).8.8
MICROPERL_SOURCE=perl-$(MICROPERL_VER).tar.bz2
MICROPERL_CAT:=$(BZCAT)
MICROPERL_SITE=ftp://ftp.cpan.org/pub/CPAN/src/5.0
MICROPERL_DIR=$(BUILD_DIR)/perl-$(MICROPERL_VER)

$(DL_DIR)/$(MICROPERL_SOURCE):
	$(WGET) -P $(DL_DIR) $(MICROPERL_SITE)/$(MICROPERL_SOURCE)

$(MICROPERL_DIR)/.source: $(DL_DIR)/$(MICROPERL_SOURCE)
	$(MICROPERL_CAT) $(DL_DIR)/$(MICROPERL_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $@

$(MICROPERL_DIR)/.configured: $(MICROPERL_DIR)/.source
	(cd $(MICROPERL_DIR) ; chmod u+w uconfig.h ; . ./uconfig.sh ; \
	 make -f Makefile.micro regen_uconfig ; \
	 $(SED) \
	 's,PRIVLIB ".*,PRIVLIB "/usr/lib/perl$(MICROPERL_MAJ)/$(MICROPERL_VER)",' \
	 -e 's,PRIVLIB_EXP ".*,PRIVLIB_EXP "/usr/lib/perl$(MICROPERL_MAJ)/$(MICROPERL_VER)",' \
	 -e 's,BIN ".*,BIN "/usr/bin",' \
	 ./uconfig.h ; \
	)
	touch $@

$(MICROPERL_DIR)/microperl: $(MICROPERL_DIR)/.configured
	$(MAKE) -f Makefile.micro CC=$(TARGET_CC) \
		OPTIMIZE="$(TARGET_CFLAGS)" -C $(MICROPERL_DIR)

$(TARGET_DIR)/usr/bin/microperl: $(MICROPERL_DIR)/microperl
	cp -dpf $(MICROPERL_DIR)/microperl $(TARGET_DIR)/usr/bin/microperl

microperl: uclibc $(TARGET_DIR)/usr/bin/microperl

microperl-source: $(DL_DIR)/$(MICROPERL_SOURCE)

microperl-clean:
	rm -f $(TARGET_DIR)/usr/bin/microperl
	-$(MAKE) -C $(MICROPERL_DIR) clean

microperl-dirclean:
	rm -rf $(MICROPERL_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MICROPERL)),y)
TARGETS+=microperl
endif
