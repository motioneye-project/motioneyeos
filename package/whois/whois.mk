################################################################################
#
# whois
#
################################################################################

WHOIS_VERSION = 5.5.6
WHOIS_SITE = http://snapshot.debian.org/archive/debian/20200216T145122Z/pool/main/w/whois
WHOIS_SOURCE = whois_$(WHOIS_VERSION).tar.xz
WHOIS_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_LIBIDN2),libidn2) \
	$(TARGET_NLS_DEPENDENCIES)
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

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
WHOIS_BUILD_TARGETS =
WHOIS_INSTALL_TARGETS = install
else
WHOIS_BUILD_TARGETS = Makefile.depend whois mkpasswd
WHOIS_INSTALL_TARGETS = install-whois install-mkpasswd
endif

define WHOIS_BUILD_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPTS) \
		$(WHOIS_BUILD_TARGETS) -C $(@D)
endef

define WHOIS_INSTALL_TARGET_CMDS
	$(WHOIS_MAKE_ENV) $(MAKE) $(WHOIS_MAKE_OPTS) \
		BASEDIR="$(TARGET_DIR)" $(WHOIS_INSTALL_TARGETS) -C $(@D)
endef

$(eval $(generic-package))
