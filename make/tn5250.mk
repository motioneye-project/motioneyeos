TN5250_SITE:=http://telia.dl.sourceforge.net/sourceforge/tn5250
TN5250_DIR:=$(BUILD_DIR)/tn5250-0.16.4
TN5250_SOURCE:=tn5250-0.16.4.tar.gz

$(DL_DIR)/$(TN5250_SOURCE):
	$(WGET) -P $(DL_DIR) $(TN5250_SITE)/$(TN5250_SOURCE) 

$(TN5250_DIR)/.dist: $(DL_DIR)/$(TN5250_SOURCE)
	gunzip -c $(DL_DIR)/$(TN5250_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	-touch $(TN5250_DIR)/.dist

$(TN5250_DIR)/.configured: $(TN5250_DIR)/.dist
	(cd $(TN5250_DIR); rm -rf config.cache; \
		PATH=$(STAGING_DIR)/bin:$$PATH CC=$(TARGET_CC1) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
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
		--disable-nls \
		--with-slang --without-x --without-ssl \
	);
	touch  $(TN5250_DIR)/.configured

$(TN5250_DIR)/tn5250: $(TN5250_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC1) -C $(TN5250_DIR)

$(TARGET_DIR)/usr/bin/tn5250: $(TN5250_DIR)/tn5250
	install -c $(TN5250_DIR)/tn5250 $(TARGET_DIR)/usr/bin/tn5250

tn5250: uclibc slang $(TARGET_DIR)/usr/bin/tn5250

tn5250-clean: 
	$(MAKE) -C $(TN5250_DIR) clean

tn5250-dirclean: 
	rm -rf $(TN5250_DIR) 



