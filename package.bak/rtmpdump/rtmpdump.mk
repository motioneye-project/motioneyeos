################################################################################
#
# rtmpdump
#
################################################################################

RTMPDUMP_VERSION = a107cef9b392616dff54fabfd37f985ee2190a6f
RTMPDUMP_SITE = git://git.ffmpeg.org/rtmpdump
RTMPDUMP_INSTALL_STAGING = YES
# Note that rtmpdump is GPLv2 but librtmp has its own license and since we only
# care about librtmp, it's LGPLv2.1+
RTMPDUMP_LICENSE = LGPLv2.1+
RTMPDUMP_LICENSE_FILES = librtmp/COPYING
RTMPDUMP_DEPENDENCIES = zlib

ifeq ($(BR2_PACKAGE_GNUTLS),y)
RTMPDUMP_DEPENDENCIES += gnutls
RTMPDUMP_CRYPTO = GNUTLS
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
RTMPDUMP_DEPENDENCIES += openssl
RTMPDUMP_CRYPTO = OPENSSL
else
# no crypto
RTMPDUMP_CRYPTO =
endif

RTMPDUMP_CFLAGS = $(TARGET_CFLAGS)

ifneq ($(BR2_STATIC_LIBS),y)
RTMPDUMP_CFLAGS += -fPIC
else
RTMPDUMP_SHARED = "SHARED="
endif

RTMPDUMP_MAKE_FLAGS = \
	CRYPTO=$(RTMPDUMP_CRYPTO) \
	prefix=/usr \
	$(RTMPDUMP_SHARED)

define RTMPDUMP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(RTMPDUMP_MAKE_FLAGS) \
		XCFLAGS="$(RTMPDUMP_CFLAGS)" \
		XLDFLAGS="$(TARGET_LDFLAGS)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		-C $(@D)/librtmp
endef

define RTMPDUMP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/librtmp install DESTDIR=$(STAGING_DIR) $(RTMPDUMP_MAKE_FLAGS)
endef

define RTMPDUMP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/librtmp install DESTDIR=$(TARGET_DIR) $(RTMPDUMP_MAKE_FLAGS)
endef

$(eval $(generic-package))
