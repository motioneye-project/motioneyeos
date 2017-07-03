################################################################################
#
# whois
#
################################################################################

WHOIS_VERSION = 5.2.14
WHOIS_SITE = http://snapshot.debian.org/archive/debian/20161230T032015Z/pool/main/w/whois
WHOIS_SOURCE = whois_$(WHOIS_VERSION).tar.xz
# take precedence over busybox implementation
WHOIS_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox) $(TARGET_NLS_DEPENDENCIES)
WHOIS_MAKE_ENV = $(TARGET_MAKE_ENV)
WHOIS_MAKE_OPTS = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
	LIBS="$(WHOIS_EXTRA_LIBS)"
WHOIS_LICENSE = GPL-2.0+
WHOIS_LICENSE_FILES = COPYING
WHOIS_EXTRA_LIBS = $(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_LIBICONV),y)
WHOIS_DEPENDENCIES += libiconv
WHOIS_EXTRA_LIBS += -liconv
WHOIS_MAKE_ENV += HAVE_ICONV=1
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
WHOIS_DEPENDENCIES += libidn
WHOIS_MAKE_ENV += HAVE_LIBIDN=1
endif

define WHOIS_BUILD_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPTS) -C $(@D)
endef

define WHOIS_INSTALL_TARGET_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPTS) \
		BASEDIR="$(TARGET_DIR)" install -C $(@D)
endef

$(eval $(generic-package))
