############################################################
#
# Tremor (Integer decoder for Vorbis)
#
############################################################

TREMOR_SITE:=http://svn.xiph.org/trunk/Tremor/
TREMOR_VERSION:=16259
TREMOR_SVNDIR = Tremor-svn-r$(TREMOR_VERSION)
TREMOR_SOURCE:= $(TREMOR_SVNDIR).tar.bz2
TREMOR_AUTORECONF = YES
TREMOR_INSTALL_STAGING = YES
TREMOR_INSTALL_TARGET = YES

$(DL_DIR)/$(TREMOR_SOURCE):
	$(SVN_CO) -r $(TREMOR_VERSION) $(TREMOR_SITE) $(BUILD_DIR)/$(TREMOR_SVNDIR)
	tar -cv -C $(BUILD_DIR) $(TREMOR_SVNDIR) | bzip2 - -c > $@
	rm -rf $(BUILD_DIR)/$(TREMOR_SVNDIR)

# use custom download step
TREMOR_TARGET_SOURCE := $(DL_DIR)/$(TREMOR_SOURCE)

$(eval $(call AUTOTARGETS,package/multimedia,tremor))
