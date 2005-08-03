#############################################################
#
# strace
#
#############################################################
STRACE_VER:=4.5.12
STRACE_SOURCE:=strace-$(STRACE_VER).tar.bz2
STRACE_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/strace
STRACE_CAT:=bzcat
STRACE_DIR:=$(BUILD_DIR)/strace-$(STRACE_VER)


$(DL_DIR)/$(STRACE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(STRACE_SITE)/$(STRACE_SOURCE)

strace-source: $(DL_DIR)/$(STRACE_SOURCE)

$(STRACE_DIR)/.unpacked: $(DL_DIR)/$(STRACE_SOURCE)
	$(STRACE_CAT) $(DL_DIR)/$(STRACE_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(STRACE_DIR) package/strace strace\*.patch
	touch $(STRACE_DIR)/.unpacked

$(STRACE_DIR)/.configured: $(STRACE_DIR)/.unpacked
	(cd $(STRACE_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--localstatedir=/var \
		--mandir=/usr/man \
		--infodir=/usr/info \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	);
	touch  $(STRACE_DIR)/.configured

$(STRACE_DIR)/strace: $(STRACE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(STRACE_DIR)

$(TARGET_DIR)/usr/bin/strace: $(STRACE_DIR)/strace
	install -c $(STRACE_DIR)/strace $(TARGET_DIR)/usr/bin/strace
	$(STRIP) $(TARGET_DIR)/usr/bin/strace > /dev/null 2>&1

strace: uclibc $(TARGET_DIR)/usr/bin/strace 

strace-clean: 
	$(MAKE) -C $(STRACE_DIR) clean

strace-dirclean: 
	rm -rf $(STRACE_DIR) 


#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_STRACE)),y)
TARGETS+=strace
endif
