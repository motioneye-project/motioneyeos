############################################################
#
# Tremor (Integer decoder for Vorbis)
#
############################################################

TREMOR_TRUNK:=http://svn.xiph.org/trunk/Tremor/
TREMOR_VERSION:=16259
TREMOR_NAME:=Tremor-svn-r$(TREMOR_VERSION)
TREMOR_DIR:=$(BUILD_DIR)/$(TREMOR_NAME)
TREMOR_SOURCE:=$(TREMOR_NAME).tar.bz2
TREMOR_CAT=$(BZCAT)
TREMOR_AUTORECONF = YES
TREMOR_INSTALL_STAGING = YES
TREMOR_INSTALL_TARGET = YES

$(DL_DIR)/$(TREMOR_SOURCE):
	$(SVN_CO) -r $(TREMOR_VERSION) $(TREMOR_TRUNK) $(TREMOR_DIR)
	tar -cv -C $(BUILD_DIR) $(TREMOR_NAME) | bzip2 - -c > $@

$(eval $(call AUTOTARGETS,package/multimedia,tremor))


############################################################
#
# Toplevel Makefile options
#
############################################################
ifeq ($(BR2_PACKAGE_TREMOR),y)
TARGETS+=tremor
endif
