#############################################################
#
# OpenNTPD
#
#############################################################
OPENNTPD_VERSION:=3.9p1
OPENNTPD_SOURCE:=openntpd-$(OPENNTPD_VERSION).tar.gz
OPENNTPD_SITE:=ftp://ftp.openbsd.org/pub/OpenBSD/OpenNTPD
OPENNTPD_DIR:=$(BUILD_DIR)/openntpd-$(OPENNTPD_VERSION)
OPENNTPD_CAT:=$(ZCAT)
OPENNTPD_BINARY:=ntpd
OPENNTPD_TARGET_BINARY:=usr/sbin/ntpd

$(DL_DIR)/$(OPENNTPD_SOURCE):
	$(WGET) -P $(DL_DIR) $(OPENNTPD_SITE)/$(OPENNTPD_SOURCE)

$(OPENNTPD_DIR)/.source: $(DL_DIR)/$(OPENNTPD_SOURCE)
	$(ZCAT) $(DL_DIR)/$(OPENNTPD_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	#mv $(BUILD_DIR)/ntpd $(OPENNTPD_DIR)
	touch $@

$(OPENNTPD_DIR)/.configured: $(OPENNTPD_DIR)/.source
	(cd $(OPENNTPD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--with-builtin-arc4random \
	)
	touch $@

$(OPENNTPD_DIR)/$(OPENNTPD_BINARY): $(OPENNTPD_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(OPENNTPD_DIR)
	#(cd $(OPENNTPD_DIR) ; \
	# $(YACC) parse.y ; \
	# $(TARGET_CC) $(TARGET_CFLAGS) $(CFLAGS_COMBINE) \
	# 	$(CFLAGS_WHOLE_PROGRAM) -I$(OPENNTPD_DIR) \
	#	-D__dead="__attribute((__noreturn__))" -DHAVE_INTXX_T=1 \
	#	-include defines.h \
	#	-o $@ \
	#	ntpd.c buffer.c log.c imsg.c ntp.c ntp_msg.c y.tab.c config.c \
	#	server.c client.c sensors.c util.c ; \
	#)
	$(STRIP) $@

$(TARGET_DIR)/$(OPENNTPD_TARGET_BINARY): $(OPENNTPD_DIR)/$(OPENNTPD_BINARY)
	rm -f $(TARGET_DIR)/etc/ntpd.conf
	$(MAKE) DESTDIR=$(TARGET_DIR) STRIP_OPT="" -C $(OPENNTPD_DIR) install
	-$(STRIP) $(TARGET_DIR)/$(OPENNTPD_TARGET_BINARY)
	cp -af $(OPENNTPD_DIR)/ntpd.conf $(TARGET_DIR)/etc/ntpd.conf
	# Why on earth do we wipe the whole man directory here?
	#rm -Rf $(TARGET_DIR)/usr/man

ntpd: uclibc $(TARGET_DIR)/$(OPENNTPD_TARGET_BINARY)

ntpd-source: $(DL_DIR)/$(OPENNTPD_SOURCE)

ntpd-clean:
	rm -f $(addprefix $(TARGET_DIR)/,etc/ntpd.conf \
					 usr/share/man/man?/ntpd.conf* \
					 $(OPENNTPD_TARGET_BINARY))
	-$(MAKE) -C $(OPENNTPD_DIR) clean

ntpd-dirclean:
	rm -rf $(OPENNTPD_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_OPENNTPD)),y)
TARGETS+=ntpd
endif

