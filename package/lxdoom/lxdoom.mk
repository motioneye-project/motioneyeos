#############################################################
#
# lxdoom
#
#############################################################

LXDOOM_VERSION = 1.4.4
LXDOOM_SOURCE = lxdoom-$(LXDOOM_VERSION).tar.gz
LXDOOM_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/lxdoom
LXDOOM_AUTORECONF = NO
LXDOOM_INSTALL_STAGING = NO
LXDOOM_INSTALL_TARGET = YES
LXDOOM_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

LXDOOM_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--includedir=/usr/include --enable-shared \
		$(DISABLE_NLS)

LXDOOM_DEPENDENCIES = uclibc  

$(eval $(call AUTOTARGETS,package,lxdoom))