################################################################################
#
# ipsec-tools
#
################################################################################

IPSEC_TOOLS_VERSION = 0.8.2
IPSEC_TOOLS_SOURCE = ipsec-tools-$(IPSEC_TOOLS_VERSION).tar.bz2
IPSEC_TOOLS_SITE = http://sourceforge.net/projects/ipsec-tools/files/ipsec-tools/$(IPSEC_TOOLS_VERSION)
IPSEC_TOOLS_INSTALL_STAGING = YES
IPSEC_TOOLS_MAKE = $(MAKE1)
IPSEC_TOOLS_DEPENDENCIES = openssl flex host-flex

# configure hardcodes -Werror, so override CFLAGS on make invocation
IPSEC_TOOLS_MAKE_OPTS = CFLAGS='$(TARGET_CFLAGS)'

# openssl uses zlib, so we need to explicitly link with it when static
ifeq ($(BR2_STATIC_LIBS),y)
IPSEC_TOOLS_CONF_ENV += LIBS=-lz
endif

IPSEC_TOOLS_CONF_OPTS = \
	  --without-libpam \
	  --disable-gssapi \
	  --with-kernel-headers=$(STAGING_DIR)/usr/include

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_ADMINPORT),y)
IPSEC_TOOLS_CONF_OPTS += --enable-adminport
else
IPSEC_TOOLS_CONF_OPTS += --disable-adminport
endif

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_NATT),y)
IPSEC_TOOLS_CONF_OPTS += --enable-natt
else
IPSEC_TOOLS_CONF_OPTS += --disable-natt
endif

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_FRAG),y)
IPSEC_TOOLS_CONF_OPTS += --enable-frag
else
IPSEC_TOOLS_CONF_OPTS += --disable-frag
endif

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_DPD),y)
IPSEC_TOOLS_CONF_OPTS += --enable-dpd
else
IPSEC_TOOLS_CONF_OPTS += --disable-dpd
endif

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_STATS),y)
IPSEC_TOOLS_CONF_OPTS += --enable-stats
else
IPSEC_TOOLS_CONF_OPTS += --disable-stats
endif

ifneq ($(BR2_PACKAGE_IPSEC_TOOLS_READLINE),y)
IPSEC_TOOLS_CONF_OPTS += --without-readline
else
IPSEC_TOOLS_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_IPSEC_TOOLS_HYBRID),y)
IPSEC_TOOLS_CONF_OPTS += --enable-hybrid
else
IPSEC_TOOLS_CONF_OPTS += --disable-hybrid
endif

ifeq ($(BR2_PACKAGE_IPSEC_SECCTX_DISABLE),y)
IPSEC_TOOLS_CONF_OPTS += --enable-security-context=no
endif
ifeq ($(BR2_PACKAGE_IPSEC_SECCTX_ENABLE),y)
IPSEC_TOOLS_CONF_OPTS += --enable-security-context=yes
endif
ifeq ($(BR2_PACKAGE_IPSEC_SECCTX_KERNEL),y)
IPSEC_TOOLS_CONF_OPTS += --enable-security-context=kernel
endif

$(eval $(autotools-package))
