TARGETS += busybox
TARGETS_CLEAN += busybox_clean
TARGETS_MRPROPER += busybox_mrproper
TARGETS_DISTCLEAN += busybox_distclean

BUSYBOX_VERSION=0.60.2

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

BUSYBOX_URI=http://www.busybox.net/downloads/
BUSYBOX_SOURCE=busybox-$(BUSYBOX_VERSION).tar.gz
BUSYBOX_DIR=$(BASE_DIR)/${shell basename $(BUSYBOX_SOURCE) .tar.gz}
BUSYBOX_WORKDIR=$(BASE_DIR)/busybox_workdir

IMAGE_SIZE += +500

$(SOURCE_DIR)/$(BUSYBOX_SOURCE):
	while [ ! -f $(SOURCE_DIR)/$(BUSYBOX_SOURCE) ] ; do \
	    wget -P $(SOURCE_DIR) --passive $(BUSYBOX_URI)/$(BUSYBOX_SOURCE) ; \
	done

$(BUSYBOX_DIR)/.unpacked:	$(SOURCE_DIR)/$(BUSYBOX_SOURCE)
	rm -rf $(BUSYBOX_DIR) # Make sure no older version interferes
	tar -xzf $(SOURCE_DIR)/$(BUSYBOX_SOURCE)
	touch $(BUSYBOX_DIR)/.unpacked
	
$(BUSYBOX_WORKDIR)/.config:	$(BUSYBOX_DIR)/.unpacked
	rm -rf $(BUSYBOX_WORKDIR) # Make sure no half-configured busybox interferes
	mkdir -p $(BUSYBOX_WORKDIR)
	(cd $(BUSYBOX_WORKDIR) && sh $(BUSYBOX_DIR)/pristine_setup.sh)
	@perl -i -p \
		-e 's|//(#define\s+BB_)(?!FEATURE)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_VERBOSE_USAGE)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_NEW_MODULE_INTERFACE)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_COMMAND_USERNAME_COMPLETION)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_SH_FANCY_PROMPT)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_INSMOD_VERSION_CHECKING)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_IFCONFIG)|$$1|;' \
		-e 's|//(#define\s+BB_FEATURE_DEVFS)|$$1|;' \
		$(BUSYBOX_WORKDIR)/Config.h
	touch $(BUSYBOX_WORKDIR)/.config

$(BUSYBOX_WORKDIR)/.built:	$(TARGET_CC) $(BUSYBOX_WORKDIR)/.config
	make CROSS="$(TARGET_CROSS)" -C $(BUSYBOX_WORKDIR)
	touch $(BUSYBOX_WORKDIR)/.built

$(TARGET_DIR)/bin/busybox:	$(BUSYBOX_WORKDIR)/.built
	make PREFIX=$(TARGET_DIR) -C $(BUSYBOX_WORKDIR) install

busybox: $(TARGET_DIR)/bin/busybox

busybox_clean:
	@if [ -d $(BUSYBOX_WORKDIR)/Makefile ] ; then \
		make -C $(BUSYBOX_WORKDIR) clean ; \
	fi;

busybox_mrproper:
	rm -rf $(BUSYBOX_DIR) $(BUSYBOX_WORKDIR)

busybox_distclean:	busybox_mrproper
	rm -f $(SOURCE_DIR)/$(BUSYBOX_SOURCE)
