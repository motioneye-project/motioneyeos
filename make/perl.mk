#############################################################
#
# perl
#
#############################################################
PERL_SOURCE:=perl-5.8.0.tar.gz
PERL_SOURCE_2:=$(SOURCE_DIR)/perl-cross-0.1.tar.gz
PERL_PATCH:=$(SOURCE_DIR)/perl.patch
PERL_SITE:=http://www.cpan.org/src/
PERL_DIR:=$(BUILD_DIR)/perl-5.8.0
PERL_CAT:=zcat
PERL_BINARY:=perl
PERL_TARGET_BINARY:=usr/bin/perl


$(DL_DIR)/$(PERL_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PERL_SITE)/$(PERL_SOURCE)

perl-source: $(DL_DIR)/$(PERL_SOURCE)

$(PERL_DIR)/.unpacked: $(DL_DIR)/$(PERL_SOURCE)
	$(PERL_CAT) $(DL_DIR)/$(PERL_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	$(PERL_CAT) $(PERL_SOURCE_2) | tar -C $(PERL_DIR) -xvf -
	cat $(PERL_PATCH) | patch -p1 -d $(PERL_DIR)
	perl -pi -e "s,^ARCH.*,ARCH=$(ARCH)," $(PERL_DIR)/cross/config
	perl -pi -e "s,^CONFIG_TARGET_.*,\#," $(PERL_DIR)/cross/config
	perl -pi -e "s,^export CROSS=.*,export CROSS=$(TARGET_CROSS)," $(PERL_DIR)/cross/Makefile
	perl -pi -e "s,TARGET_ARCH,$(ARCH)," $(PERL_DIR)/cross/config.sh.uclibc
	perl -pi -e "s,TARGET_CROSS,$(TARGET_CROSS)," $(PERL_DIR)/cross/config.sh.uclibc
	touch $(PERL_DIR)/.unpacked

$(PERL_DIR)/.configured: $(PERL_DIR)/.unpacked
	$(MAKE) CC=$(TARGET_CC) -C $(PERL_DIR)/cross patch
	touch  $(PERL_DIR)/.configured

$(PERL_DIR)/$(PERL_BINARY): $(PERL_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(PERL_DIR)/cross perl

$(TARGET_DIR)/$(PERL_TARGET_BINARY): $(PERL_DIR)/$(PERL_BINARY)
	rm -f $(PERL_DIR)/install_me_here/usr/lib/perl/5.8.0/*-linux/.packlist
	rm -f $(PERL_DIR)/install_me_here/usr/lib/perl/5.8.0/ExtUtils/MANIFEST.SKIP
	rm -f $(PERL_DIR)/install_me_here/usr/lib/perl/5.8.0/unicore/Makefile
	rm -rf $(TARGET_DIR)/usr/lib/perl
	cp -fa $(PERL_DIR)/install_me_here/* $(TARGET_DIR)/
	rm -rf $(TARGET_DIR)/share/locale $(TARGET_DIR)/usr/info \
		$(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc

perl: uclibc $(TARGET_DIR)/$(PERL_TARGET_BINARY)

perl-clean:
	$(MAKE) DESTDIR=$(TARGET_DIR) CC=$(TARGET_CC) -C $(PERL_DIR) uninstall
	-$(MAKE) -C $(PERL_DIR) clean

perl-dirclean:
	rm -rf $(PERL_DIR)

