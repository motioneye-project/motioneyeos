################################################################################
#
# dmalloc
#
################################################################################

DMALLOC_VERSION = 5.5.2
DMALLOC_SOURCE = dmalloc-$(DMALLOC_VERSION).tgz
DMALLOC_SITE = http://dmalloc.com/releases

DMALLOC_LICENSE = MIT-like
# license is in each file, dmalloc.h.1 is the smallest one
DMALLOC_LICENSE_FILES = dmalloc.h.1

DMALLOC_INSTALL_STAGING = YES
DMALLOC_CONF_OPTS = --enable-shlib
DMALLOC_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_INSTALL_LIBSTDCPP),y)
DMALLOC_CONF_OPTS += --enable-cxx
else
DMALLOC_CONF_OPTS += --disable-cxx
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
DMALLOC_CONF_OPTS += --enable-threads
else
DMALLOC_CONF_OPTS += --disable-threads
endif

# dmalloc has some assembly function that are not present in thumb1 mode:
# Error: lo register required -- `str lr,[sp,#4]'
# so, we desactivate thumb mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
DMALLOC_CFLAGS += -marm
endif

DMALLOC_CONF_ENV = CFLAGS="$(DMALLOC_CFLAGS)"

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

ifeq ($(BR2_STATIC_LIBS),)
define DMALLOC_INSTALL_SHARED_LIB
	cp -dpf $(STAGING_DIR)/usr/lib/libdmalloc*.so $(TARGET_DIR)/usr/lib
endef
endif

define DMALLOC_INSTALL_TARGET_CMDS
	$(DMALLOC_INSTALL_SHARED_LIB)
	cp -dpf $(STAGING_DIR)/usr/bin/dmalloc $(TARGET_DIR)/usr/bin/dmalloc
endef

$(eval $(autotools-package))
