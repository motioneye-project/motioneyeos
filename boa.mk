# 
TARGETS += boa
TARGETS_CLEAN += boa_clean
TARGETS_MRPROPER += boa_mrproper
TARGETS_DISTCLEAN += boa_distclean

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

BOA_DIR=$(BASE_DIR)/${shell basename $(BOA_SOURCE) .tar.gz}
BOA_WORKDIR=$(BASE_DIR)/boa_workdir
BOA_URI=http://www.boa.org
BOA_SOURCE=boa-0.94.12pre1.tar.gz

IMAGE_SIZE += +100

$(SOURCE_DIR)/$(BOA_SOURCE):
	while [ ! -f $(SOURCE_DIR)/$(BOA_SOURCE) ] ; do \
		wget -P $(SOURCE_DIR) --passive-ftp $(BOA_URI)/$(BOA_SOURCE); \
	done

$(BOA_DIR)/.unpacked:	$(SOURCE_DIR)/$(BOA_SOURCE)
	tar -xzf $(SOURCE_DIR)/$(BOA_SOURCE)
	touch $(BOA_DIR)/.unpacked

$(BOA_WORKDIR)/Makefile: uclibc $(BOA_DIR)/.unpacked
	mkdir -p $(BOA_WORKDIR)
	if [ -f $(SOURCE_DIR)/boa-config.site-$(ARCH) ]; then \
		(cd $(BOA_WORKDIR) && CONFIG_SITE=$(SOURCE_DIR)/boa-config.site-$(ARCH) CC=$(TARGET_CC) $(BOA_DIR)/src/configure); \
	else \
		(cd $(BOA_WORKDIR) && CC=$(TARGET_CC) $(BOA_DIR)/src/configure); \
	fi

$(BOA_WORKDIR)/.built:	$(BOA_WORKDIR)/Makefile
	touch $(BOA_WORKDIR)/.depend
	make VPATH=$(BOA_DIR)/src/ -C $(BOA_WORKDIR)
	(cd $(BOA_WORKDIR) && strip --strip-all boa boa_indexer)
	touch $(BOA_WORKDIR)/.built

boa_install_dirs = /usr/sbin /etc/boa /usr/lib/boa /var/www /usr/lib/cgi-bin

TARGET_DIRS = $(foreach dir,$(boa_install_dirs),$(TARGET_DIR)/$(dir))

$(TARGET_DIRS):
	mkdir -p $@

boa:	$(BOA_WORKDIR)/.built $(TARGET_DIRS) 
	@A=`cksum $(TARGET_DIR)/usr/sbin/boa 2>/dev/null | awk '{ print $$1 }'`; \
	B=`cksum $(BOA_WORKDIR)/boa 2>/dev/null | awk '{ print $$1 }'`; \
	if [ "$$A" != "$$B" ] ; then \
		cp -f $(BOA_WORKDIR)/boa $(TARGET_DIR)/usr/sbin/boa ; \
	fi;
	@A=`cksum $(TARGET_DIR)/usr/lib/boa/boa_indexer 2>/dev/null | awk '{ print $$1 }'`; \
	B=`cksum $(BOA_WORKDIR)/boa_indexer 2>/dev/null | awk '{ print $$1 }'`; \
	if [ "$$A" != "$$B" ] ; then \
		cp -f $(BOA_WORKDIR)/boa_indexer $(TARGET_DIR)/usr/lib/boa/boa_indexer ; \
	fi;
	@A=`cksum $(TARGET_DIR)/etc/boa/boa.conf 2>/dev/null | awk '{ print $$1 }'`; \
	B=`cksum $(SOURCE_DIR)/boa.conf 2>/dev/null | awk '{ print $$1 }'`; \
	if [ "$$A" != "$$B" ] ; then \
		cp -f $(SOURCE_DIR)/boa.conf $(TARGET_DIR)/etc/boa ; \
	fi;
	@A=`cksum $(TARGET_DIR)/etc/mime.types 2>/dev/null | awk '{ print $$1 }'`; \
	B=`cksum $(SOURCE_DIR)/mime.types 2>/dev/null | awk '{ print $$1 }'`; \
	if [ "$$A" != "$$B" ] ; then \
		cp -f $(SOURCE_DIR)/mime.types $(TARGET_DIR)/etc/mime.types ; \
	fi;

boa_clean:
	@if [ -d $(BOA_WORKDIR)/Makefile ] ; then \
		make -C $(BOA_WORKDIR) clean ; \
	fi;

boa_mrproper:
	rm -rf $(BOA_DIR) $(BOA_WORKDIR)

boa_distclean:	boa_mrproper
	rm -f $(SOURCE_DIR)/$(BOA_SOURCE)
