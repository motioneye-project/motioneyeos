#############################################################
#
# automake
#
#############################################################
AUTOMAKE_SOURCE:=automake-1.6.3.tar.bz2
AUTOMAKE_SITE:=ftp://ftp.gnu.org/gnu/automake
AUTOMAKE_CAT:=bzcat
AUTOMAKE_DIR:=$(BUILD_DIR)/automake-1.6.3
AUTOMAKE_BINARY:=automake
AUTOMAKE_TARGET_BINARY:=usr/bin/automake

$(DL_DIR)/$(AUTOMAKE_SOURCE):
	 $(WGET) -P $(DL_DIR) $(AUTOMAKE_SITE)/$(AUTOMAKE_SOURCE)

automake-source: $(DL_DIR)/$(AUTOMAKE_SOURCE)

$(AUTOMAKE_DIR)/.unpacked: $(DL_DIR)/$(AUTOMAKE_SOURCE)
	$(AUTOMAKE_CAT) $(DL_DIR)/$(AUTOMAKE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(AUTOMAKE_DIR)/.unpacked

$(AUTOMAKE_DIR)/.configured: $(AUTOMAKE_DIR)/.unpacked
	(cd $(AUTOMAKE_DIR); rm -f config.cache; CC=$(TARGET_CC1) \
	    CFLAGS=-D_POSIX_SOURCE ./configure \
		--target=i386-uclibc \
		--prefix=/usr \
		--exec-prefix=/usr \
	);
	touch  $(AUTOMAKE_DIR)/.configured

$(AUTOMAKE_DIR)/$(AUTOMAKE_BINARY): $(AUTOMAKE_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(AUTOMAKE_DIR)

$(TARGET_DIR)/$(AUTOMAKE_TARGET_BINARY): $(AUTOMAKE_DIR)/$(AUTOMAKE_BINARY)
	PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
	$(MAKE) \
	    prefix=$(TARGET_DIR)/usr \
	    exec_prefix=$(TARGET_DIR)/usr \
	    bindir=$(TARGET_DIR)/usr/bin \
	    sbindir=$(TARGET_DIR)/usr/sbin \
	    libexecdir=$(TARGET_DIR)/usr/lib \
	    datadir=$(TARGET_DIR)/usr/share \
	    sysconfdir=$(TARGET_DIR)/etc \
	    localstatedir=$(TARGET_DIR)/var \
	    libdir=$(TARGET_DIR)/usr/lib \
	    infodir=$(TARGET_DIR)/usr/info \
	    mandir=$(TARGET_DIR)/usr/man \
	    includedir=$(TARGET_DIR)/usr/include \
	    -C $(AUTOMAKE_DIR) install;
	rm -rf $(TARGET_DIR)/share/locale

automake: uclibc $(TARGET_DIR)/$(AUTOMAKE_TARGET_BINARY)

automake-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC1) -C $(AUTOMAKE_DIR) uninstall
	-make -C $(AUTOMAKE_DIR) clean

automake-dirclean:
	rm -rf $(AUTOMAKE_DIR)

