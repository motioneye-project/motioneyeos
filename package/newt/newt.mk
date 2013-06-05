################################################################################
#
# newt
#
################################################################################

NEWT_VERSION         = 0.51.0
NEWT_SITE            = http://www.uclibc.org/
NEWT_SOURCE          = newt-$(NEWT_VERSION).tar.bz2
NEWT_LICENSE         = GPLv2
NEWT_LICENSE_FILES   = COPYING
NEWT_INSTALL_STAGING = YES

NEWT_DEPENDENCIES = slang

NEWT_MAKE_ENV += $(TARGET_CONFIGURE_OPTS)
NEWT_MAKE = $(MAKE1)

define NEWT_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m644 $(@D)/newt.h    $(STAGING_DIR)/usr/include/newt.h
	$(INSTALL) -D -m644 $(@D)/libnewt.a $(STAGING_DIR)/usr/lib/libnewt.a
	$(INSTALL) -m755 $(@D)/libnewt.so*  $(STAGING_DIR)/usr/lib/
	ln -fs libnewt.so.$(NEWT_VERSION)   $(STAGING_DIR)/usr/lib/libnewt.so
	ln -fs libnewt.so.$(NEWT_VERSION)   $(STAGING_DIR)/usr/lib/libnewt.so.0.51
endef

define NEWT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m644 $(@D)/newt.h    $(TARGET_DIR)/usr/include/newt.h
	$(INSTALL) -D -m644 $(@D)/libnewt.a $(TARGET_DIR)/usr/lib/libnewt.a
	$(INSTALL) -m755 $(@D)/libnewt.so*  $(TARGET_DIR)/usr/lib/
	ln -fs libnewt.so.$(NEWT_VERSION)   $(TARGET_DIR)/usr/lib/libnewt.so
	ln -fs libnewt.so.$(NEWT_VERSION)   $(TARGET_DIR)/usr/lib/libnewt.so.0.51
endef

$(eval $(autotools-package))
