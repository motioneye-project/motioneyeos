#############################################################
#
# liberation
#
#############################################################
LIBERATION_VERSION = 1.04
LIBERATION_SITE = http://www.fedorahosted.org/releases/l/i/liberation-fonts
LIBERATION_SOURCE = liberation-fonts-$(LIBERATION_VERSION).tar.gz
LIBERATION_DIR = $(BUILD_DIR)/liberation-fonts-$(LIBERATION_VERSION)
LIBERATION_CAT:=$(ZCAT)

$(DL_DIR)/$(LIBERATION_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBERATION_SITE)/$(LIBERATION_SOURCE)

liberation-source: $(DL_DIR)/$(LIBERATION_SOURCE)

$(LIBERATION_DIR)/.unpacked: $(DL_DIR)/$(LIBERATION_SOURCE)
	$(LIBERATION_CAT) $(DL_DIR)/$(LIBERATION_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBERATION_DIR)/.unpacked

$(STAGING_DIR)/usr/share/fonts/LiberationMono-Bold.ttf: $(LIBERATION_DIR)/.unpacked
	-mkdir -p $(STAGING_DIR)/usr/share/fonts/liberation
	$(INSTALL) -m0644 $(LIBERATION_DIR)/*.ttf $(STAGING_DIR)/usr/share/fonts/liberation/
	touch -c $(STAGING_DIR)/usr/share/fonts/.ttf

$(TARGET_DIR)/usr/share/fonts/LiberationMono-Bold.ttf: $(STAGING_DIR)/usr/share/fonts/.ttf
	-mkdir -p $(TARGET_DIR)/usr/share/fonts/liberation
	$(INSTALL) -m0644 $(LIBERATION_DIR)/*.ttf $(TARGET_DIR)/usr/share/fonts/liberation/
	touch -c $(TARGET_DIR)/usr/share/fonts/.ttf

liberation: uclibc $(TARGET_DIR)/usr/share/fonts/LiberationMono-Bold.ttf

liberation-clean:
	rm -rf $(TARGET_DIR)/usr/share/fonts/liberation/
	rm -rf $(STAGING_DIR)/usr/share/fonts/liberation/

liberation-dirclean:
	rm -rf $(LIBERATION_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBERATION)),y)
TARGETS+=liberation
endif
