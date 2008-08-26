#############################################################
#
# blackbox
#
#############################################################

BLACKBOX_VERSION = 0.70.1
BLACKBOX_SOURCE = blackbox-$(BLACKBOX_VERSION).tar.bz2
BLACKBOX_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/blackboxwm/
BLACKBOX_AUTORECONF = NO
BLACKBOX_INSTALL_STAGING = NO
BLACKBOX_INSTALL_TARGET = YES
BLACKBOX_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

BLACKBOX_CONF_OPT =	--target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--sysconfdir=/etc --x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib


BLACKBOX_DEPENDENCIES = uclibc $(XSERVER)

$(eval $(call AUTOTARGETS,package,blackbox))
