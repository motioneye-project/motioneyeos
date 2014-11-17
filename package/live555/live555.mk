################################################################################
#
# live555
#
################################################################################

LIVE555_VERSION = 2014.11.01
LIVE555_SOURCE = live.$(LIVE555_VERSION).tar.gz
LIVE555_SITE = http://www.live555.com/liveMedia/public
LIVE555_LICENSE = LGPLv2.1+
LIVE555_LICENSE_FILES = COPYING
LIVE555_INSTALL_STAGING = YES

LIVE555_CFLAGS = $(TARGET_CFLAGS)

ifndef ($(BR2_ENABLE_LOCALE),y)
LIVE555_CFLAGS += -DLOCALE_NOT_USED
endif

define LIVE555_CONFIGURE_CMDS
	echo 'COMPILE_OPTS = $$(INCLUDES) -I. -DSOCKLEN_T=socklen_t $(LIVE555_CFLAGS)' >> $(@D)/config.linux
	echo 'C_COMPILER = $(TARGET_CC)' >> $(@D)/config.linux
	echo 'CPLUSPLUS_COMPILER = $(TARGET_CXX)' >> $(@D)/config.linux
	echo 'LINK = $(TARGET_CXX) -o' >> $(@D)/config.linux
	echo 'LINK_OPTS = -L. $(TARGET_LDFLAGS)' >> $(@D)/config.linux
	echo 'PREFIX = /usr' >> $(@D)/config.linux
	(cd $(@D); ./genMakefiles linux)
endef

define LIVE555_BUILD_CMDS
	$(MAKE) -C $(@D) all
endef

LIVE555_FILES_TO_INSTALL-y =
LIVE555_FILES_TO_INSTALL-$(BR2_PACKAGE_LIVE555_OPENRTSP) += testProgs/openRTSP
LIVE555_FILES_TO_INSTALL-$(BR2_PACKAGE_LIVE555_MEDIASERVER) += mediaServer/live555MediaServer
LIVE555_FILES_TO_INSTALL-$(BR2_PACKAGE_LIVE555_MPEG2_INDEXER) += testProgs/MPEG2TransportStreamIndexer

define LIVE555_INSTALL_STAGING_CMDS
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define LIVE555_INSTALL_TARGET_CMDS
	for i in $(LIVE555_FILES_TO_INSTALL-y); do \
		$(INSTALL) -D -m 0755 $(@D)/$$i $(TARGET_DIR)/usr/bin/`basename $$i`; \
	done
endef

$(eval $(generic-package))
