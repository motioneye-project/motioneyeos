#############################################################
#
# libaio
#
#############################################################
LIBAIO_VERSION=0.3.106-avr32
LIBAIO_SOURCE=libaio-$(LIBAIO_VERSION).tar.bz2
LIBAIO_SITE=http://avr32linux.org/twiki/pub/Main/LibAio/
LIBAIO_DIR=$(BUILD_DIR)/libaio-$(LIBAIO_VERSION)
LIBAIO_SOVER=1.0.1

LIBAIO_ARCH:=$(ARCH)
LIBAIO_MAKEOPTS:= $(TARGET_CONFIGURE_OPTS) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS) -nostdlib -nostartfiles -I. -fPIC" LDFLAGS="$(TARGET_LDFLAGS)"

$(DL_DIR)/$(LIBAIO_SOURCE):
	$(WGET) -P $(DL_DIR) $(LIBAIO_SITE)/$(LIBAIO_SOURCE)

$(LIBAIO_DIR)/.unpacked: $(DL_DIR)/$(LIBAIO_SOURCE)
	$(BZCAT) $(DL_DIR)/$(LIBAIO_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LIBAIO_DIR) package/libaio libaio\*.patch
	touch $@

$(LIBAIO_DIR)/src/libaio.so.$(LIBAIO_SOVER): $(LIBAIO_DIR)/.unpacked
	$(MAKE) -C $(LIBAIO_DIR) $(LIBAIO_MAKEOPTS)

$(STAGING_DIR)/usr/lib/libaio.so: $(LIBAIO_DIR)/src/libaio.so.$(LIBAIO_SOVER)
	$(MAKE) -C $(LIBAIO_DIR) $(LIBAIO_MAKEOPTS) prefix=$(STAGING_DIR)/usr install

$(TARGET_DIR)/usr/lib/libaio.so: $(STAGING_DIR)/usr/lib/libaio.so
	cp -dpf $(STAGING_DIR)/usr/lib/libaio.so* $(TARGET_DIR)/usr/lib/
	-$(STRIP) --strip-unneeded $(TARGET_DIR)/usr/lib/libaio.so

libaio: uclibc $(TARGET_DIR)/usr/lib/libaio.so

libaio-source: $(DL_DIR)/$(LIBAIO_SOURCE)

libaio-clean:
	-$(MAKE) -C $(LIBAIO_DIR) $(LIBAIO_MAKEOPTS) clean

libaio-dirclean:
	rm -rf $(LIBAIO_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LIBAIO)),y)
TARGETS+=libaio
endif
