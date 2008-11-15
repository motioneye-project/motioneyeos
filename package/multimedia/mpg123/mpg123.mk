#############################################################
#
# mpg123
#
#############################################################
MPG123_VERSION=0.66
MPG123_SOURCE=mpg123-$(MPG123_VERSION).tar.bz2
MPG123_CAT:=$(BZCAT)
MPG123_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mpg123
MPG123_DIR:=$(BUILD_DIR)/mpg123-$(MPG123_VERSION)
MPG123_BIN:=src/mpg123
MPG123_TARGET_BIN:=usr/bin/mpg123

# Check if ALSA is built, then we should configure after alsa-lib so
# ./configure can find alsa-lib.
ifeq ($(strip $(BR2_PACKAGE_MPG123_ALSA)),y)
MPG123_USE_ALSA:=--with-audio=alsa
MPG123_ALSA_DEP:=alsa-lib
endif

$(DL_DIR)/$(MPG123_SOURCE):
	$(WGET) -P $(DL_DIR) $(MPG123_SITE)/$(MPG123_SOURCE)

$(MPG123_DIR)/.unpacked: $(DL_DIR)/$(MPG123_SOURCE)
	$(MPG123_CAT) $(DL_DIR)/$(MPG123_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MPG123_DIR) package/multimedia/mpg123/ mpg123-$(MPG123_VERSION)\*.patch
	$(CONFIG_UPDATE) $(MPG123_DIR)/build
	touch $@

$(MPG123_DIR)/.configured: $(MPG123_DIR)/.unpacked
	(cd $(MPG123_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		./configure \
		--target=$(REAL_GNU_TARGET_NAME) \
		--host=$(REAL_GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--with-cpu=generic_nofpu \
		$(MPG123_USE_ALSA) \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
	)
	touch $@

$(MPG123_DIR)/$(MPG123_BIN): $(MPG123_DIR)/.configured
	$(MAKE) -C $(MPG123_DIR)

$(TARGET_DIR)/$(MPG123_TARGET_BIN): $(MPG123_DIR)/$(MPG123_BIN)
	$(INSTALL) -D $(MPG123_DIR)/$(MPG123_BIN) $(TARGET_DIR)/$(MPG123_TARGET_BIN)
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(MPG123_TARGET_BIN)

mpg123: uclibc $(MPG123_ALSA_DEP) $(TARGET_DIR)/$(MPG123_TARGET_BIN)

mpg123-clean:
	-$(MAKE) -C $(MPG123_DIR) clean

mpg123-dirclean:
	rm -rf $(MPG123_DIR) $(MPG123_DIR)

mpg123-source: $(DL_DIR)/$(MPG123_SOURCE)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MPG123)),y)
TARGETS+=mpg123
endif
