################################################################################
#
# heirloom-mailx
#
################################################################################

HEIRLOOM_MAILX_VERSION = 12.5
HEIRLOOM_MAILX_SOURCE  = heirloom-mailx_$(HEIRLOOM_MAILX_VERSION).orig.tar.gz
HEIRLOOM_MAILX_SITE    = http://snapshot.debian.org/archive/debian/20110427T035506Z/pool/main/h/heirloom-mailx/

ifeq ($(BR2_PACKAGE_OPENSSL),y)
HEIRLOOM_MAILX_DEPENDENCIES += openssl
endif

define HEIRLOOM_MAILX_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) $(SHELL) ./makeconfig)
endef

define HEIRLOOM_MAILX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HEIRLOOM_MAILX_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		PREFIX=/usr \
		UCBINSTALL=$(INSTALL) \
		STRIP=/bin/true \
		DESTDIR=$(TARGET_DIR) \
		install
endef

$(eval $(generic-package))
