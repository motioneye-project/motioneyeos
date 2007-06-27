#############################################################
#
# ipsec-tools
#
#############################################################

IPSEC_TOOLS_VER:=0.6.7
IPSEC_TOOLS_SOURCE:=ipsec-tools-$(IPSEC_TOOLS_VER).tar.bz2
IPSEC_TOOLS_CAT:=$(BZCAT)
IPSEC_TOOLS_DIR:=$(BUILD_DIR)/ipsec-tools-$(IPSEC_TOOLS_VER)

IPSEC_TOOLS_BINARY_SETKEY:=src/setkey/setkey
IPSEC_TOOLS_BINARY_RACOON:=src/racoon/racoon
IPSEC_TOOLS_BINARY_RACOONCTL:=src/racoon/racoonctl

IPSEC_TOOLS_TARGET_BINARY_SETKEY:=usr/sbin/setkey
IPSEC_TOOLS_TARGET_BINARY_RACOON:=usr/sbin/racoon
IPSEC_TOOLS_TARGET_BINARY_RACOONCTL:=usr/sbin/racoonctl
IPSEC_TOOLS_SITE=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/ipsec-tools/

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_ADMINPORT)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--enable-adminport
else
IPSEC_TOOLS_CONFIG_FLAGS+=	--disable-adminport
endif

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_NATT)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--enable-natt
else
IPSEC_TOOLS_CONFIG_FLAGS+=	--disable-natt
endif

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_FRAG)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--enable-frag
else
IPSEC_TOOLS_CONFIG_FLAGS+=	--disable-frag
endif

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_STATS)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--enable-stats
else
IPSEC_TOOLS_CONFIG_FLAGS+=	--disable-stats
endif

ifeq ($(BR2_INET_IPV6),y)

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_IPV6)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--enable-ipv6
else
IPSEC_TOOLS_CONFIG_FLAGS+=	$(DISABLE_IPV6)
endif

else # ignore user's choice if it doesn't
IPSEC_TOOLS_CONFIG_FLAGS+=	$(DISABLE_IPV6)
endif

ifneq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_READLINE)), y)
IPSEC_TOOLS_CONFIG_FLAGS+=	--without-readline
endif

$(DL_DIR)/$(IPSEC_TOOLS_SOURCE):
	$(WGET) -P $(DL_DIR) $(IPSEC_TOOLS_SITE)/$(IPSEC_TOOLS_SOURCE)

$(IPSEC_TOOLS_DIR)/.patched: $(DL_DIR)/$(IPSEC_TOOLS_SOURCE)
	$(IPSEC_TOOLS_CAT) $(DL_DIR)/$(IPSEC_TOOLS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(IPSEC_TOOLS_DIR) package/ipsec-tools ipsec-tools-$(IPSEC_TOOLS_VER)\*.patch
	$(CONFIG_UPDATE) $(IPSEC_TOOLS_DIR)
	touch $@

$(IPSEC_TOOLS_DIR)/.configured: $(IPSEC_TOOLS_DIR)/.patched
	( cd $(IPSEC_TOOLS_DIR); rm -rf config.cache ; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
	  ./configure \
	  --target=$(GNU_TARGET_NAME) \
	  --host=$(GNU_TARGET_NAME) \
	  --build=$(GNU_HOST_NAME) \
	  --prefix=/usr \
	  --sysconfdir=/etc \
	  --disable-hybrid \
	  --without-libpam \
	  --disable-gssapi \
	  --with-kernel-headers=$(STAGING_DIR)/usr/include \
	  $(IPSEC_TOOLS_CONFIG_FLAGS) \
	); 
	# simpler than patching that cruft..
	(echo '#undef bzero' ; \
	 echo '#define bzero(a, b) memset((a), 0, (b))' ; \
	 echo '#undef bcopy' ; \
	 echo '#define bcopy(src, dest, len) memmove(dest, src, len)' ; \
	 echo '#undef index' ; \
	 echo '#define index(a, b) strchr(a, b)' ; \
	) >> $(IPSEC_TOOLS_DIR)/config.h
	touch $@

$(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_SETKEY) \
$(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_RACOON) \
$(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_RACOONCTL): \
    $(IPSEC_TOOLS_DIR)/.configured
	$(MAKE) CC=$(TARGET_CC) -C $(IPSEC_TOOLS_DIR)
	
$(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_SETKEY) \
$(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOON) \
$(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOONCTL): \
  $(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_SETKEY) \
  $(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_RACOON) \
  $(IPSEC_TOOLS_DIR)/$(IPSEC_TOOLS_BINARY_RACOONCTL) 
	$(MAKE) -C $(IPSEC_TOOLS_DIR) DESTDIR=$(TARGET_DIR) install
	$(STRIP) --strip-unneeded --remove-section=.comment \
          --remove-section=.note \
	  $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_SETKEY) \
	  $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOON) \
	  $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOONCTL)
	-rm -f $(TARGET_DIR)/usr/man/man3/ipsec_strerror.3 \
	  $(TARGET_DIR)/usr/man/man3/ipsec_set_policy.3 \
	  $(TARGET_DIR)/usr/man/man5/racoon.conf.5 \
	  $(TARGET_DIR)/usr/man/man8/racoonctl.8 \
	  $(TARGET_DIR)/usr/man/man8/racoon.8 \
	  $(TARGET_DIR)/usr/man/man8/plainrsa-gen.8 \
	  $(TARGET_DIR)/usr/man/man8/setkey.8
ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_LIBS)), y)
	install -D $(IPSEC_TOOLS_DIR)/src/libipsec/.libs/libipsec.a \
	  $(IPSEC_TOOLS_DIR)/src/libipsec/.libs/libipsec.la \
	  $(IPSEC_TOOLS_DIR)/src/racoon/.libs/libracoon.a \
	  $(IPSEC_TOOLS_DIR)/src/racoon/.libs/libracoon.la \
	  $(STAGING_DIR)/lib
endif
ifneq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_ADMINPORT)), y)
	-rm -f $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOONCTL)
endif

IPSEC_TOOLS_PROGS= $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_SETKEY) \
    $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOON)

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_ADMINPORT)), y)
IPSEC_TOOLS_PROGS+= $(TARGET_DIR)/$(IPSEC_TOOLS_TARGET_BINARY_RACOONCTL)
endif

ipsec-tools: uclibc openssl $(IPSEC_TOOLS_PROGS)

ipsec-tools-source: $(DL_DIR)/$(IPSEC_TOOLS_SOURCE)

ipsec-tools-uninstall:

ipsec-tools-clean:
	$(MAKE) -C $(IPSEC_TOOLS_DIR) DESTDIR=$(TARGET_DIR) uninstall
	$(MAKE) -C $(IPSEC_TOOLS_DIR) clean
ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS_LIBS)), y)
	-rm -f $(STAGING_DIR)/lib/libipsec.a
	-rm -f $(STAGING_DIR)/lib/libipsec.la
	-rm -f $(STAGING_DIR)/lib/libracoon.a
	-rm -f $(STAGING_DIR)/lib/libracoon.la
endif
	-rm $(IPSEC_TOOLS_DIR)/.configured

ipsec-tools-dirclean:
	@echo $(LINUX_DIR)
	-rm -rf $(IPSEC_TOOLS_DIR)

ifeq ($(strip $(BR2_PACKAGE_IPSEC_TOOLS)), y)
TARGETS+=ipsec-tools
endif 
