#############################################################
#
# tinylogin
#
#############################################################
# Enable this to use the tinylogin daily snapshot
TINYLOGIN_VERSION:=1.4
USE_TINYLOGIN_SNAPSHOT=true

ifeq ($(USE_TINYLOGIN_SNAPSHOT),true)
# Be aware that this changes daily....
TINYLOGIN_DIR:=$(BUILD_DIR)/tinylogin
TINYLOGIN_SOURCE:=tinylogin-snapshot.tar.bz2
TINYLOGIN_SITE:=http://tinylogin.busybox.net/downloads/snapshots
else
TINYLOGIN_DIR:=$(BUILD_DIR)/tinylogin-$(TINYLOGIN_VERSION)
TINYLOGIN_SOURCE:=tinylogin-$(TINYLOGIN_VERSION).tar.bz2
TINYLOGIN_SITE:=http://tinylogin.busybox.net/downloads
endif
TINYLOGIN_CAT:=$(BZCAT)

$(DL_DIR)/$(TINYLOGIN_SOURCE):
	$(WGET) -P $(DL_DIR) $(TINYLOGIN_SITE)/$(TINYLOGIN_SOURCE)

tinylogin-source: $(DL_DIR)/$(TINYLOGIN_SOURCE)

$(TINYLOGIN_DIR)/Config.h: $(DL_DIR)/$(TINYLOGIN_SOURCE)
	$(TINYLOGIN_CAT) $(DL_DIR)/$(TINYLOGIN_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(SED) "s/\`id -u\` -ne 0/0 == 1/" \
		$(TINYLOGIN_DIR)/install.sh
	$(SED) "s/4755 --owner=root --group=root/755/" \
		$(TINYLOGIN_DIR)/install.sh
	$(SED) "s/^DOSTATIC.*/DOSTATIC=false/g;" $(TINYLOGIN_DIR)/Makefile
	$(SED) "s/^DODEBUG.*/DODEBUG=false/g;" $(TINYLOGIN_DIR)/Makefile
	# date test this one
	touch $(TINYLOGIN_DIR)/Config.h

$(TINYLOGIN_DIR)/tinylogin: $(TINYLOGIN_DIR)/Config.h
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" \
		CFLAGS_EXTRA="$(TARGET_CFLAGS)" -C $(TINYLOGIN_DIR)

$(TARGET_DIR)/bin/tinylogin: $(TINYLOGIN_DIR)/tinylogin
	$(MAKE) CC=$(TARGET_CC) CROSS="$(TARGET_CROSS)" \
		PREFIX="$(TARGET_DIR)" -C $(TINYLOGIN_DIR) \
		CFLAGS_EXTRA="$(TARGET_CFLAGS)" install

tinylogin: uclibc $(TARGET_DIR)/bin/tinylogin

tinylogin-clean:
	rm -f $(TARGET_DIR)/bin/tinylogin
	-$(MAKE) -C $(TINYLOGIN_DIR) clean

tinylogin-dirclean:
	rm -rf $(TINYLOGIN_DIR)
#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_TINYLOGIN),y)
TARGETS+=tinylogin
endif
