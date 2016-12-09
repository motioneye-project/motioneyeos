################################################################################
#
# ezxml
#
################################################################################

EZXML_VERSION = 0.8.6
EZXML_SITE = http://downloads.sourceforge.net/project/ezxml/ezXML/ezXML%20$(EZXML_VERSION)
EZXML_INSTALL_STAGING = YES
EZXML_LICENSE = MIT
EZXML_LICENSE_FILES = license.txt

EZXML_CFLAGS = $(TARGET_CFLAGS)

# mmap code uses madvise which isn't available on nommu uClibc
ifeq ($(BR2_USE_MMU),)
EZXML_CFLAGS += -D EZXML_NOMMAP
endif

define EZXML_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) -f GNUmakefile \
		CC="$(TARGET_CC)" CFLAGS="$(EZXML_CFLAGS)" AR=$(TARGET_AR)
endef

define EZXML_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/ezxml.h $(STAGING_DIR)/usr/include/ezxml.h
	$(INSTALL) -D -m 0644 $(@D)/libezxml.a $(STAGING_DIR)/usr/lib/libezxml.a
endef

define EZXML_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/ezxml.h $(TARGET_DIR)/usr/include/ezxml.h
	$(INSTALL) -D -m 0644 $(@D)/libezxml.a $(TARGET_DIR)/usr/lib/libezxml.a
endef

$(eval $(generic-package))
