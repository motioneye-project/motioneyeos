#############################################################
#
# mpg123
#
#############################################################

MPG123_VERSION=0.59r

# Don't alter below this line unless you (think) you know
# what you are doing! Danger, Danger!

MPG123_SOURCE=mpg123-$(MPG123_VERSION).tar.gz
MPG123_CAT:=$(ZCAT)
MPG123_SITE=http://www.mpg123.de/mpg123
MPG123_DIR=$(BUILD_DIR)/${shell basename $(MPG123_SOURCE) .tar.gz}
MPG123_WORKDIR=$(BUILD_DIR)/mpg123-$(MPG123_VERSION)

$(DL_DIR)/$(MPG123_SOURCE):
	$(WGET) -P $(DL_DIR) $(MPG123_SITE)/$(MPG123_SOURCE)

$(MPG123_DIR)/.unpacked:	$(DL_DIR)/$(MPG123_SOURCE)
	$(MPG123_CAT) $(DL_DIR)/$(MPG123_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPG123_DIR) package/mpg123/ mpg123\*.patch
	touch $(MPG123_DIR)/.unpacked

$(MPG123_WORKDIR)/mpg123:	$(MPG123_DIR)/.unpacked
	rm -f $@
ifeq ($(BR2_ARCH),"i386")
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(MPG123_WORKDIR) linux
else
ifeq ($(BR2_ENDIAN),"LITTLE")
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(MPG123_WORKDIR) linux-littleend
else
	$(MAKE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" -C $(MPG123_WORKDIR) linux-bigend
endif
endif

$(MPG123_WORKDIR)/.installed: 	$(MPG123_WORKDIR)/mpg123
	mkdir -p $(TARGET_DIR)/usr/bin
	cp -f $(MPG123_WORKDIR)/mpg123 $(TARGET_DIR)/usr/bin
	$(STRIP) --strip-all $(TARGET_DIR)/usr/bin/mpg123
	touch $(MPG123_WORKDIR)/.installed

mpg123:	uclibc libmad $(MPG123_WORKDIR)/.installed

mpg123-source: $(DL_DIR)/$(MPG123_SOURCE)

mpg123-clean:
	@if [ -d $(MPG123_WORKDIR)/Makefile ] ; then \
		$(MAKE) -C $(MPG123_WORKDIR) clean ; \
	fi;

mpg123-dirclean:
	rm -rf $(MPG123_DIR) $(MPG123_WORKDIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MPG123)),y)
TARGETS+=mpg123
endif
