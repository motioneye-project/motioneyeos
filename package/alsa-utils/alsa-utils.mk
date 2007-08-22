#############################################################
#
# alsa-utils
#
#############################################################
ALSA_UTILS_VERSION:=1.0.14
ALSA_UTILS_SOURCE:=alsa-utils-$(ALSA_UTILS_VERSION).tar.bz2
ALSA_UTILS_SITE:=ftp://ftp.alsa-project.org/pub/utils
ALSA_UTILS_DIR:=$(BUILD_DIR)/alsa-utils-$(ALSA_UTILS_VERSION)
ALSA_UTILS_CAT:=$(BZCAT)
ALSA_UTILS_BINARY:=alsactl/alsactl
ALSA_UTILS_TARGET_BINARY:=usr/sbin/alsactl

$(DL_DIR)/$(ALSA_UTILS_SOURCE):
	$(WGET) -P $(DL_DIR) $(ALSA_UTILS_SITE)/$(ALSA_UTILS_SOURCE)

$(ALSA_UTILS_DIR)/.unpacked: $(DL_DIR)/$(ALSA_UTILS_SOURCE)
	$(ALSA_UTILS_CAT) $(DL_DIR)/$(ALSA_UTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(ALSA_UTILS_DIR) package/alsa-utils/ alsa-utils-$(ALSA_UTILS_VERSION)\*.patch\*
	$(CONFIG_UPDATE) $(ALSA_UTILS_DIR)
	touch $@

$(ALSA_UTILS_DIR)/.configured: $(ALSA_UTILS_DIR)/.unpacked
	(cd $(ALSA_UTILS_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
	)
	touch $@

$(ALSA_UTILS_DIR)/$(ALSA_UTILS_BINARY): $(ALSA_UTILS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(ALSA_UTILS_DIR)
	touch -c $@

ALSA_UTILS_TARGETS_ :=
ALSA_UTILS_TARGETS_y :=

ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSACONF)	+= usr/sbin/alsaconf
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSACTL)	+= usr/sbin/alsactl
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSAMIXER)	+= usr/bin/alsamixer
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_AMIDI)	+= usr/bin/amidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_AMIXER)	+= usr/bin/amixer
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_APLAY)	+= usr/bin/aplay
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ARECORD)	+= usr/bin/arecord
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_IECSET)	+= usr/bin/iecset
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ACONNECT)	+= usr/bin/aconnect
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_APLAYMIDI)	+= usr/bin/aplaymidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ARECORDMIDI)	+= usr/bin/arecordmidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ASEQDUMP)	+= usr/bin/aseqdump
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ASEQNET)	+= usr/bin/aseqnet
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_SPEAKER_TEST)	+= usr/bin/speaker-test

$(TARGET_DIR)/$(ALSA_UTILS_TARGET_BINARY): $(ALSA_UTILS_DIR)/$(ALSA_UTILS_BINARY)
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(ALSA_UTILS_DIR) install
	mkdir -p $(TARGET_DIR)/usr/bin
	mkdir -p $(TARGET_DIR)/usr/sbin
	for file in $(ALSA_UTILS_TARGETS_y); do \
		cp -dpf $(STAGING_DIR)/$$file $(TARGET_DIR)/$$file; \
	done
	if [ -x "$(TARGET_DIR)/usr/bin/speaker-test" ]; then \
		mkdir -p $(TARGET_DIR)/usr/share/alsa/speaker-test; \
		mkdir -p $(TARGET_DIR)/usr/share/sounds/alsa; \
		cp -rdpf $(STAGING_DIR)/usr/share/alsa/speaker-test/* $(TARGET_DIR)/usr/share/alsa/speaker-test/; \
		cp -rdpf $(STAGING_DIR)/usr/share/sounds/alsa/* $(TARGET_DIR)/usr/share/sounds/alsa/; \
	fi
	touch -c $@

alsa-utils: uclibc alsa-lib ncurses $(TARGET_DIR)/$(ALSA_UTILS_TARGET_BINARY)

alsa-utils-clean:
	for file in $(ALSA_UTILS_TARGETS_y); do \
		rm -f $(TARGET_DIR)/$$file; \
	done
	for file in $(ALSA_UTILS_TARGETS_); do \
		rm -f $(TARGET_DIR)/$$file; \
	done
	-$(MAKE) -C $(ALSA_UTILS_DIR) clean

alsa-utils-dirclean:
	rm -rf $(ALSA_UTILS_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_ALSA_UTILS)),y)
TARGETS+=alsa-utils
endif
