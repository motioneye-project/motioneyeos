#############################################################
#
# build GNU readline 
#
#############################################################
READLINE_VER:=5.0
READLINE_SITE:=ftp://ftp.cwru.edu/pub/bash
READLINE_SOURCE:=readline-$(READLINE_VER).tar.gz
#READLINE_DIR1:=$(TOOL_BUILD_DIR)/readline-$(READLINE_VER)
READLINE_DIR1:=$(BUILD_DIR)/readline-$(READLINE_VER)
#READLINE_DIR2:=$(BUILD_DIR)/readline-$(READLINE_VER)
READLINE_CAT:=zcat

##READLINE_BINARY:=readline
##READLINE_TARGET_BINARY:=usr/bin/readline
#READLINE_BINARY:=libreadline.a
READLINE_BINARY:=libhistory.so.$(READLINE_VER)
READLINE_TARGET_BINARY:=$(TARGET_DIR)/lib/$(READLINE_BINARY)
#READLINE_TARGET_BINARY:=$(DEST_DIR)/usr/lib/libreadline.a



$(DL_DIR)/$(READLINE_SOURCE):
	$(WGET) -P $(DL_DIR) $(READLINE_SITE)/$(READLINE_SOURCE)

$(READLINE_DIR1)/.unpacked: $(DL_DIR)/$(READLINE_SOURCE)
	$(READLINE_CAT) $(DL_DIR)/$(READLINE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	# patch to fix old autoconf
	patch -d $(READLINE_DIR1) -p1 -u  < $(BASE_DIR)/package/readline/readline5.patch
	touch $(READLINE_DIR1)/.unpacked


#		--target=$(GNU_HOST_NAME) \
# gnu-host-name: $(GNU_HOST_NAME)  powerpc-pc-linux-gnu   
#		--host=powerpc-linux-uclibc \
#		--program-prefix=$(TARGET_CROSS) \

$(READLINE_DIR1)/.configured: $(READLINE_DIR1)/.unpacked
	mkdir -p $(READLINE_DIR1)
	# gnu-host-name: $(GNU_HOST_NAME) 
	(cd $(READLINE_DIR1); rm -rf config.cache; \
		$(READLINE_DIR1)/configure \
		--build=powerpc-linux-uclibc \
		--host=powerpc-linux-uclibc \
		--prefix=$(STAGING_DIR) \
	);
	touch $(READLINE_DIR1)/.configured

# old:		--prefix=$(TARGET_DIR) \
# oldest:	--prefix=$(TARGET_DIR)/opt/vp \

# -SAJ changed HOSTCC to TARGET_CC
$(READLINE_DIR1)/$(READLINE_BINARY): $(READLINE_DIR1)/.configured
	#$(MAKE) -e CC=$(TARGET_CC) -C $(READLINE_DIR1)
	$(MAKE)  -C $(READLINE_DIR1)
	#$(MAKE) -e CC=$(TARGET_CC) -C $(READLINE_DIR1) install
	# $(MAKE) -e CC=$(TARGET_CC) -C $(READLINE_DIR1) DESTDIR=$(TARGET_DIR)/opt/vp install

$(STAGING_DIR)/$(READLINE_TARGET_BINARY): $(READLINE_DIR1)/$(READLINE_BINARY)
	#$(MAKE) -e CC=$(TARGET_CC) -C $(READLINE_DIR1)  install
	$(MAKE) -C $(READLINE_DIR1)  install

readline: $(STAGING_DIR)/$(READLINE_TARGET_BINARY)
	# VP- do these post-install steps to clean up runtime env.
	# VP- remove static libs from runtime environment
	# also install  .so library files to target root
	$(MAKE) -C $(READLINE_DIR1)  install-shared DESTDIR=$(TARGET_DIR)
	### rm $(TARGET_DIR)/lib/libreadline.a
	## #rm $(TARGET_DIR)/lib/libhistory.a
	# VP- remove backup versions runtime environment
	## #rm $(TARGET_DIR)/lib/libreadline*old
	## #rm $(TARGET_DIR)/lib/libhistory*old

readline-clean:
	$(MAKE) -C $(READLINE_DIR1) uninstall
	-$(MAKE) -C $(READLINE_DIR1) clean

readline-dirclean:
	rm -rf $(READLINE_DIR1)

readline-source:  $(DL_DIR)/$(READLINE_SOURCE)   $(READLINE_DIR1)/.unpacked

ifeq ($(strip $(BR2_READLINE)),y)
TARGETS+=readline
endif
ifeq ($(strip $(BR2_PACKAGE_READLINE_TARGET)),y)
TARGETS+=readline_target
endif
