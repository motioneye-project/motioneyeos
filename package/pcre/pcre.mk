#############################################################
#
# PCRE
#
#############################################################

PCRE_VERSION = 7.9
PCRE_SITE = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
PCRE_INSTALL_STAGING = YES

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
# pcre will use the host g++ if a cross version isn't available
PCRE_CONF_OPT = --disable-cpp
endif

$(eval $(call AUTOTARGETS,package,pcre))

$(PCRE_HOOK_POST_INSTALL): $(PCRE_TARGET_INSTALL_TARGET)
	$(SED) 's,^prefix=.*,prefix=$(STAGING_DIR)/usr,' \
		-e 's,^exec_prefix=.*,exec_prefix=$(STAGING_DIR)/usr,' \
		$(STAGING_DIR)/usr/bin/pcre-config
	rm -rf $(TARGET_DIR)/usr/share/doc/pcre
ifneq ($(BR2_HAVE_DEVFILES),y)
	rm -f $(TARGET_DIR)/usr/bin/pcre-config
endif
	touch $@
