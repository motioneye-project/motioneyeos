#############################################################
#
# sed
#
#############################################################
SED_SOURCE:=sed-3.02.tar.gz
SED_SITE:=ftp://ftp.gnu.org/gnu/sed
SED_CAT:=zcat
SED_DIR:=$(BUILD_DIR)/sed-3.02
SED_BINARY:=sed/sed
SED_TARGET_BINARY:=bin/sed
ifeq ($(strip $(BUILD_WITH_LARGEFILE)),true)
SED_CPPFLAGS=-D_FILE_OFFSET_BITS=64
endif

$(DL_DIR)/$(SED_SOURCE):
	 $(WGET) -P $(DL_DIR) $(SED_SITE)/$(SED_SOURCE)

sed-source: $(DL_DIR)/$(SED_SOURCE)

$(SED_DIR)/.unpacked: $(DL_DIR)/$(SED_SOURCE)
	$(SED_CAT) $(DL_DIR)/$(SED_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(SED_DIR)/.unpacked

$(SED_DIR)/.configured: $(SED_DIR)/.unpacked
	(cd $(SED_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS="$(SED_CFLAGS)" \
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
	);
	touch  $(SED_DIR)/.configured

$(SED_DIR)/$(SED_BINARY): $(SED_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(SED_DIR)

# This stuff is needed to work around GNU make deficiencies
sed-target_binary: $(SED_DIR)/$(SED_BINARY)
	@if [ -L $(TARGET_DIR)/$(SED_TARGET_BINARY) ] ; then \
		rm -f $(TARGET_DIR)/$(SED_TARGET_BINARY); fi;
	@if [ $(TARGET_DIR)/$(SED_TARGET_BINARY) -ot $(SED_DIR)/$(SED_BINARY) ] ; then \
	set -x; \
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR) install; \
	mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/; \
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc; fi

sed: uclibc sed-target_binary

sed-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(SED_DIR) uninstall
	-sed -C $(SED_DIR) clean

sed-dirclean:
	rm -rf $(SED_DIR)

