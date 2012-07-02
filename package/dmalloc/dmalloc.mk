#############################################################
#
# dmalloc
#
#############################################################
DMALLOC_VERSION:=5.4.3
DMALLOC_SOURCE:=dmalloc-$(DMALLOC_VERSION).tgz
DMALLOC_SITE:=http://dmalloc.com/releases

DMALLOC_INSTALL_STAGING = YES
DMALLOC_CONF_OPT:= --enable-shlib

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
DMALLOC_CONF_OPT+=--enable-cxx
else
DMALLOC_CONF_OPT+=--disable-cxx
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
DMALLOC_CONF_OPT+=--enable-threads
else
DMALLOC_CONF_OPT+=--disable-threads
endif

define DMALLOC_POST_PATCH
	$(SED) 's/^ac_cv_page_size=0$$/ac_cv_page_size=12/' $(@D)/configure
	$(SED) 's/(ld -/($${LD-ld} -/' $(@D)/configure
	$(SED) 's/'\''ld -/"$${LD-ld}"'\'' -/' $(@D)/configure
	$(SED) 's/ar cr/$$(AR) cr/' $(@D)/Makefile.in
endef

DMALLOC_POST_PATCH_HOOKS += DMALLOC_POST_PATCH

# both DESTDIR and PREFIX are ignored..
define DMALLOC_INSTALL_STAGING_CMDS
	$(MAKE) includedir="$(STAGING_DIR)/usr/include" \
		bindir="$(STAGING_DIR)/usr/bin" \
		libdir="$(STAGING_DIR)/usr/lib" \
		shlibdir="$(STAGING_DIR)/usr/lib" \
		infodir="$(STAGING_DIR)/usr/share/info/" \
		-C $(@D) install
endef

define DMALLOC_INSTALL_TARGET_CMDS
	mv $(STAGING_DIR)/usr/lib/libdmalloc*.so $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/bin/dmalloc $(TARGET_DIR)/usr/bin/dmalloc
endef

define DMALLOC_CLEAN_CMDS
	-rm -f $(TARGET_DIR)/usr/lib/libdmalloc*
	-rm -f $(STAGING_DIR)/usr/lib/libdmalloc*
	rm -f $(STAGING_DIR)/usr/include/dmalloc.h
	rm -f $(TARGET_DIR)/usr/bin/dmalloc
	-$(MAKE) -C $(DMALLOC_DIR) clean
endef


$(eval $(autotools-package))
