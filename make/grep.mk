#############################################################
#
# grep
#
#############################################################
GNUGREP_SOURCE:=grep-2.5.1.tar.bz2
GNUGREP_SITE:=ftp://ftp.gnu.org/gnu/grep
GNUGREP_DIR:=$(BUILD_DIR)/grep-2.5.1
GNUGREP_CAT:=bzcat
GNUGREP_BINARY:=src/grep
GNUGREP_TARGET_BINARY:=bin/grep

$(DL_DIR)/$(GNUGREP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(GNUGREP_SITE)/$(GNUGREP_SOURCE)

grep-source: $(DL_DIR)/$(GNUGREP_SOURCE)

$(GNUGREP_DIR)/.unpacked: $(DL_DIR)/$(GNUGREP_SOURCE)
	$(GNUGREP_CAT) $(DL_DIR)/$(GNUGREP_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $(GNUGREP_DIR)/.unpacked

$(GNUGREP_DIR)/.configured: $(GNUGREP_DIR)/.unpacked
	(cd $(GNUGREP_DIR); rm -rf config.cache; \
		PATH=$(TARGET_PATH) CC=$(TARGET_CC) \
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
	);
	touch  $(GNUGREP_DIR)/.configured

$(GNUGREP_DIR)/$(GNUGREP_BINARY): $(GNUGREP_DIR)/.configured
	$(MAKE) -C $(GNUGREP_DIR)

$(TARGET_DIR)/$(GNUGREP_TARGET_BINARY): $(GNUGREP_DIR)/$(GNUGREP_BINARY)
	rm -f $(TARGET_DIR)/bin/grep $(TARGET_DIR)/bin/egrep $(TARGET_DIR)/bin/fgrep
	cp -a $(GNUGREP_DIR)/src/grep $(GNUGREP_DIR)/src/egrep $(GNUGREP_DIR)/src/fgrep $(TARGET_DIR)/bin/ 


grep: uclibc $(TARGET_DIR)/$(GNUGREP_TARGET_BINARY)

grep-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(GNUGREP_DIR) uninstall
	-$(MAKE) -C $(GNUGREP_DIR) clean

grep-dirclean:
	rm -rf $(GNUGREP_DIR)

