#############################################################
#
# libcgi
#
#############################################################
LIBCGI_VERSION:=1.0
LIBCGI_SOURCE:=libcgi-$(LIBCGI_VERSION).tar.gz
LIBCGI_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libcgi
LIBCGI_DIR:=$(BUILD_DIR)/libcgi-$(LIBCGI_VERSION)
LIBCGI_LIBRARY:=libcgi
LIBCGI_TARGET_LIBRARY:=usr/bin/libcgi

$(DL_DIR)/$(LIBCGI_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBCGI_SITE)/$(LIBCGI_SOURCE)

$(LIBCGI_DIR)/.source: $(DL_DIR)/$(LIBCGI_SOURCE)
	zcat $(DL_DIR)/$(LIBCGI_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(LIBCGI_DIR)/.source

$(LIBCGI_DIR)/.configured: $(LIBCGI_DIR)/.source
	(cd $(LIBCGI_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		./configure \
			--target=$(GNU_TARGET_NAME) \
			--host=$(GNU_TARGET_NAME) \
			--build=$(GNU_HOST_NAME) \
			--prefix=/usr \
			--sysconfdir=/etc \
	);
	touch $(LIBCGI_DIR)/.configured;

$(LIBCGI_DIR)/$(LIBCGI_LIBRARY): $(LIBCGI_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(LIBCGI_DIR)

$(TARGET_DIR)/$(LIBCGI_TARGET_LIBRARY): $(LIBCGI_DIR)/$(LIBCGI_LIBRARY)
	cp $(LIBCGI_DIR)/src/libcgi.so $(TARGET_DIR)/usr/lib/

libcgi: uclibc $(TARGET_DIR)/$(LIBCGI_TARGET_LIBRARY)

libcgi-source: $(DL_DIR)/$(LIBCGI_SOURCE)

libcgi-clean:
	rm $(TARGET_DIR)/usr/lib/libcgi.so

	-$(MAKE) -C $(LIBCGI_DIR) clean

libcgi-dirclean:
	rm -rf $(LIBCGI_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBCGI)),y)
	TARGETS+=libcgi
endif

