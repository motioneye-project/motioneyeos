#############################################################
#
# speex
#
#############################################################

SPEEX_VERSION=1.2beta2

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

SPEEX_SOURCE=speex-$(SPEEX_VERSION).tar.gz
SPEEX_CAT:=$(ZCAT)
SPEEX_SITE=http://downloads.us.xiph.org/releases/speex
SPEEX_DIR=$(BUILD_DIR)/speex-$(SPEEX_VERSION)

ifeq ($(BR2_PACKAGE_SPEEX_ARM5E),y)
SPEEX_FOR_ARM5E:=--enable-arm5e-asm
endif

$(DL_DIR)/$(SPEEX_SOURCE):
	$(WGET) -P $(DL_DIR) $(SPEEX_SITE)/$(SPEEX_SOURCE)

$(SPEEX_DIR)/.unpacked: $(DL_DIR)/$(SPEEX_SOURCE)
	$(SPEEX_CAT) $(DL_DIR)/$(SPEEX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	touch $(SPEEX_DIR)/.unpacked

$(SPEEX_DIR)/Makefile: $(SPEEX_DIR)/.unpacked
	rm -f $(SPEEX_DIR)/Makefile
	mkdir -p $(SPEEX_DIR)
	(cd $(SPEEX_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		$(SPEEX_DIR)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--includedir=/usr/include \
		--enable-shared \
		--enable-fixed-point \
		$(SPEEX_FOR_ARM5E) \
		$(DISABLE_NLS); \
	)
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/Makefile
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/libspeex/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/libspeex/Makefile
	$(SED) "s,-I/usr/include,,g" $(SPEEX_DIR)/libspeex/Makefile
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/src/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/src/Makefile
	$(SED) "s,-I/usr/include,,g" $(SPEEX_DIR)/src/Makefile
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/include/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/include/Makefile
	$(SED) "s,-I/usr/include,,g" $(SPEEX_DIR)/include/Makefile
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/include/speex/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/include/speex/Makefile
	$(SED) "s,-I/usr/include,,g" $(SPEEX_DIR)/include/speex/Makefile
	$(SED) "s,^OGG_CFLAGS.*,OGG_CFLAGS= -I$(STAGING_DIR)/usr/include,g" $(SPEEX_DIR)/doc/Makefile
	$(SED) "s,^OGG_LIBS.*,OGG_LIBS= -L$(STAGING_DIR)/usr/lib -logg,g" $(SPEEX_DIR)/doc/Makefile
	$(SED) "s,-I/usr/include,,g" $(SPEEX_DIR)/doc/Makefile



$(SPEEX_DIR)/speex: $(SPEEX_DIR)/Makefile
	rm -f $@
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(SPEEX_DIR)

$(SPEEX_DIR)/.installed: $(SPEEX_DIR)/speex
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(SPEEX_DIR) install
	$(SED) "s,^libdir=.*,libdir=\'$(STAGING_DIR)/usr/lib\',g" $(STAGING_DIR)/usr/lib/libspeex.la
	touch $@

$(TARGET_DIR)/usr/bin/speexdec: $(SPEEX_DIR)/.installed
	cp -dpf $(STAGING_DIR)/usr/bin/speexdec $(TARGET_DIR)/usr/bin/speexdec

$(TARGET_DIR)/usr/bin/speexenc: $(TARGET_DIR)/usr/bin/speexdec
	cp -dpf $(STAGING_DIR)/usr/bin/speexenc $(TARGET_DIR)/usr/bin/speexenc

$(TARGET_DIR)/usr/lib/libspeex.so: $(TARGET_DIR)/usr/bin/speexenc
	cp -dpf $(STAGING_DIR)/usr/lib/libspeex.so* $(TARGET_DIR)/usr/lib

speex-bins:	

speex: uclibc libogg $(TARGET_DIR)/usr/lib/libspeex.so

speex-source: $(DL_DIR)/$(SPEEX_SOURCE)

speex-clean:
	@if [ -d $(SPEEX_DIR)/Makefile ]; then \
		$(MAKE) -C $(SPEEX_DIR) clean; \
	fi

speex-dirclean:
	rm -rf $(SPEEX_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_SPEEX)),y)
TARGETS+=speex
endif
