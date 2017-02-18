################################################################################
#
# norm
#
################################################################################

NORM_VERSION = 1.5r6
NORM_SITE = http://downloads.pf.itd.nrl.navy.mil/norm/archive
NORM_SOURCE = src-norm-$(NORM_VERSION).tgz
NORM_INSTALL_STAGING = YES
NORM_LICENSE = NRL License
NORM_LICENSE_FILES = LICENSE.TXT

ifeq ($(BR2_PACKAGE_LIBNETFILTER_QUEUE),y)
NORM_DEPENDENCIES += libnetfilter_queue
endif

define NORM_CONFIGURE_CMDS
	cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		./waf configure --prefix=/usr
endef

define NORM_BUILD_CMDS
	cd $(@D); \
		$(TARGET_MAKE_ENV) \
		./waf build
endef

# install target doesn't install headers unfortunately...
define NORM_INSTALL_STAGING_CMDS
	cd $(@D); \
		$(TARGET_MAKE_ENV) \
		DESTDIR=$(STAGING_DIR) \
		./waf install
	cp -f $(@D)/include/norm* $(STAGING_DIR)/usr/include
endef

define NORM_INSTALL_TARGET_CMDS
	cd $(@D); \
		$(TARGET_MAKE_ENV) \
		DESTDIR=$(TARGET_DIR) \
		./waf install
endef

$(eval $(generic-package))
