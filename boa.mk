# 
TARGETS += boa
TARGETS_CLEAN += boa_clean
TARGETS_MRPROPER += boa_mrproper
TARGETS_DISTCLEAN += boa_distclean

BOA_VERSION=0.94.12pre1

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

BOA_URI=http://www.boa.org
BOA_SOURCE=boa-$(BOA_VERSION).tar.gz
BOA_DIR=$(BASE_DIR)/${shell basename $(BOA_SOURCE) .tar.gz}
BOA_WORKDIR=$(BASE_DIR)/boa_workdir

IMAGE_SIZE += +100

$(SOURCE_DIR)/$(BOA_SOURCE):
	while [ ! -f $(SOURCE_DIR)/$(BOA_SOURCE) ] ; do \
		wget -P $(SOURCE_DIR) --passive-ftp $(BOA_URI)/$(BOA_SOURCE); \
	done

$(BOA_DIR)/.unpacked:	$(SOURCE_DIR)/$(BOA_SOURCE)
	tar -xzf $(SOURCE_DIR)/$(BOA_SOURCE)
	touch $(BOA_DIR)/.unpacked

$(BOA_WORKDIR)/Makefile: $(TARGET_CC) $(BOA_DIR)/.unpacked
	rm -f $(BOA_WORKDIR)/Makefile
	mkdir -p $(BOA_WORKDIR)
	if [ -f $(SOURCE_DIR)/boa-config.site-$(ARCH) ]; then \
		(cd $(BOA_WORKDIR) && CONFIG_SITE=$(SOURCE_DIR)/boa-config.site-$(ARCH) CC=$(TARGET_CC) $(BOA_DIR)/src/configure); \
	else \
		(cd $(BOA_WORKDIR) && CC=$(TARGET_CC) $(BOA_DIR)/src/configure); \
	fi
	touch $(BOA_WORKDIR)/.depend
        
$(BOA_WORKDIR)/boa $(BOA_WORKDIR)/boa_indexer:	$(BOA_WORKDIR)/Makefile
	rm -f $@
	make VPATH=$(BOA_DIR)/src/ -C $(BOA_WORKDIR)

$(BOA_WORKDIR)/.installed: $(BOA_WORKDIR)/boa $(BOA_WORKDIR)/boa_indexer
	mkdir -p $(TARGET_DIR)/usr/sbin
	cp -f $(BOA_WORKDIR)/boa $(TARGET_DIR)/usr/sbin/boa
	mkdir -p $(TARGET_DIR)/usr/lib/boa
	cp -f $(BOA_WORKDIR)/boa_indexer $(TARGET_DIR)/usr/lib/boa/boa_indexer
	mkdir -p $(TARGET_DIR)/etc/boa
	cp -f $(SOURCE_DIR)/boa.conf $(TARGET_DIR)/etc/boa
	cp -f $(SOURCE_DIR)/mime.types $(TARGET_DIR)/etc/mime.types
	strip --strip-all $(TARGET_DIR)/usr/sbin/boa $(TARGET_DIR)/usr/lib/boa/boa_indexer
	touch $(BOA_WORKDIR)/.installed

boa:	$(BOA_WORKDIR)/.installed

boa_clean:
	@if [ -d $(BOA_WORKDIR)/Makefile ] ; then \
		make -C $(BOA_WORKDIR) clean ; \
	fi;

boa_mrproper:
	rm -rf $(BOA_DIR) $(BOA_WORKDIR)

boa_distclean:	boa_mrproper
	rm -f $(SOURCE_DIR)/$(BOA_SOURCE)
