################################################################################
#
# aircrack-ng
#
################################################################################

AIRCRACK_NG_VERSION = 1.1
AIRCRACK_NG_SITE = http://download.aircrack-ng.org
AIRCRACK_NG_LICENSE = GPLv2+
AIRCRACK_NG_LICENSE_FILES = LICENSE
AIRCRACK_NG_DEPENDENCIES = openssl

ifeq ($(BR2_PACKAGE_SQLITE),y)
	AIRCRACK_NG_MAKE_OPTS = sqlite=true
	AIRCRACK_NG_MAKE_OPTS += \
		LIBSQL="-lsqlite3$(if $(BR2_PREFER_STATIC_LIB), -ldl -lpthread)"

	AIRCRACK_NG_DEPENDENCIES += sqlite
else
	AIRCRACK_NG_MAKE_OPTS = sqlite=false
endif

AIRCRACK_NG_LDFLAGS = $(TARGET_LDFLAGS) -lz \
	$(if $(BR2_PREFER_STATIC_LIB),-ldl -lpthread)

define AIRCRACK_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) CC="$(TARGET_CC)" LD="$(TARGET_LD)" \
		LDFLAGS="$(AIRCRACK_NG_LDFLAGS)" \
		-C $(@D) $(AIRCRACK_NG_MAKE_OPTS) all
endef

define AIRCRACK_NG_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) \
		prefix=/usr $(AIRCRACK_NG_MAKE_OPTS) install
endef

$(eval $(generic-package))
