################################################################################
#
# dejavu
#
################################################################################

DEJAVU_VERSION = 2.35
DEJAVU_SITE = http://sourceforge.net/projects/dejavu/files/dejavu/$(DEJAVU_VERSION)
DEJAVU_SOURCE = dejavu-fonts-ttf-$(DEJAVU_VERSION).tar.bz2
DEJAVU_LICENSE_FILES = LICENSE

DEJAVU_FONTS_INSTALL =
DEJAVU_FONTCONFIG_CONF_INSTALL =

ifeq ($(BR2_PACKAGE_DEJAVU_MONO),y)
DEJAVU_FONTS_INSTALL += DejaVuSansMono*.ttf
DEJAVU_FONTCONFIG_CONF_INSTALL += \
	20-unhint-small-dejavu-sans-mono.conf \
	57-dejavu-sans-mono.conf
endif

ifeq ($(BR2_PACKAGE_DEJAVU_SANS),y)
DEJAVU_FONTS_INSTALL += DejaVuSans.ttf DejaVuSans-*.ttf
DEJAVU_FONTCONFIG_CONF_INSTALL += \
	20-unhint-small-dejavu-sans.conf \
	57-dejavu-sans.conf
endif

ifeq ($(BR2_PACKAGE_DEJAVU_SERIF),y)
DEJAVU_FONTS_INSTALL += DejaVuSerif.ttf DejaVuSerif-*.ttf
DEJAVU_FONTCONFIG_CONF_INSTALL += \
	20-unhint-small-dejavu-serif.conf \
	57-dejavu-serif.conf
endif

ifeq ($(BR2_PACKAGE_DEJAVU_SANS_CONDENSED),y)
DEJAVU_FONTS_INSTALL += DejaVuSansCondensed*.ttf
endif

ifeq ($(BR2_PACKAGE_DEJAVU_SERIF_CONDENSED),y)
DEJAVU_FONTS_INSTALL += DejaVuSerifCondensed*.ttf
endif

ifeq ($(BR2_PACKAGE_FONTCONFIG),y)
define DEJAVU_FONTCONFIG_CONF_INSTALL_CMDS
	for i in $(DEJAVU_FONTCONFIG_CONF_INSTALL) ; do \
		$(INSTALL) -D -m 0644 $(@D)/fontconfig/$$i \
			$(TARGET_DIR)/usr/share/fontconfig/conf.avail/$$i || exit 1 ; \
	done
endef
endif

define DEJAVU_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/fonts/dejavu/
	for i in $(DEJAVU_FONTS_INSTALL) ; do \
		$(INSTALL) -m 0644 $(@D)/ttf/$$i \
			$(TARGET_DIR)/usr/share/fonts/dejavu/ || exit 1 ; \
	done
	$(DEJAVU_FONTCONFIG_CONF_INSTALL_CMDS)
endef

$(eval $(generic-package))
