#############################################################
#
# openssh
#
#############################################################

OPENSSH_SITE:=ftp://mirror.cs.wisc.edu/pub/mirrors/OpenBSD/OpenSSH/portable/
OPENSSH_DIR:=$(BUILD_DIR)/openssh-3.4p1
OPENSSH_SOURCE:=openssh-3.4p1.tar.gz
OPENSSH_PATCH:=$(SOURCE_DIR)/openssh_3.4p1-4.diff.gz

$(DL_DIR)/$(OPENSSH_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENSSH_SITE)/$(OPENSSH_SOURCE)

$(OPENSSH_DIR)/.unpacked: $(DL_DIR)/$(OPENSSH_SOURCE)
	zcat $(DL_DIR)/$(OPENSSH_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch  $(OPENSSH_DIR)/.unpacked

$(OPENSSH_DIR)/.patched: $(OPENSSH_DIR)/.unpacked
	zcat $(OPENSSH_PATCH) | patch -d $(OPENSSH_DIR) -p1
	touch $(OPENSSH_DIR)/.patched

$(OPENSSH_DIR)/.configured: $(OPENSSH_DIR)/.patched
	(cd $(OPENSSH_DIR); rm -rf config.cache; CC=$(TARGET_CC1) \
	./configure --prefix=/usr \
	    --includedir=$(STAGING_DIR)/include \
	    --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx \
	    --disable-nls --without-x);
	touch  $(OPENSSH_DIR)/.configured

$(OPENSSH_DIR)/ssh: $(OPENSSH_DIR)/.configured
	make CC=$(TARGET_CC1) -C $(OPENSSH_DIR)
	-$(STRIP) --strip-unneeded $(OPENSSH_DIR)/*.so*

$(TARGET_DIR)/usr/bin/ssh: $(OPENSSH_DIR)/ssh
	make CC=$(TARGET_CC1) DESTDIR=$(TARGET_DIR) -C $(OPENSSH_DIR) install
	rm -rf $(TARGET_DIR)/usr/info $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

openssh: $(TARGET_DIR)/usr/bin/ssh

openssh-clean: 
	make -C $(OPENSSH_DIR) clean

openssh-dirclean: 
	rm -rf $(OPENSSH_DIR)

