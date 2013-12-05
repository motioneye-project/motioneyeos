################################################################################
#
# proftpd
#
################################################################################

PROFTPD_VERSION = 1.3.3g
PROFTPD_SOURCE = proftpd-$(PROFTPD_VERSION).tar.bz2
PROFTPD_SITE = ftp://ftp.proftpd.org/distrib/source/
PROFTPD_LICENSE = GPLv2+
PROFTPD_LICENSE_FILES = COPYING

PROFTPD_CONF_ENV = ac_cv_func_setpgrp_void=yes \
		ac_cv_func_setgrent_void=yes

PROFTPD_CONF_OPT = --localstatedir=/var/run \
		--disable-static \
		--disable-curses \
		--disable-ncurses \
		--disable-facl \
		--disable-dso \
		--enable-shadow \
		--with-gnu-ld

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_REWRITE),y)
PROFTPD_CONF_OPT += --with-modules=mod_rewrite
endif

define PROFTPD_MAKENAMES
	$(MAKE1) CC="$(HOSTCC)" CFLAGS="" LDFLAGS="" -C $(@D)/lib/libcap _makenames
endef

PROFTPD_POST_CONFIGURE_HOOKS = PROFTPD_MAKENAMES

PROFTPD_MAKE=$(MAKE1)

define PROFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/proftpd $(TARGET_DIR)/usr/sbin/proftpd
	@if [ ! -f $(TARGET_DIR)/etc/proftpd.conf ]; then \
		$(INSTALL) -m 0644 -D $(@D)/sample-configurations/basic.conf $(TARGET_DIR)/etc/proftpd.conf; \
		$(if $(BR2_INET_IPV6),,$(SED) 's/^UseIPv6/# UseIPv6/' $(TARGET_DIR)/etc/proftpd.conf;) \
	fi
	$(INSTALL) -m 0755 package/proftpd/S50proftpd $(TARGET_DIR)/etc/init.d
endef

$(eval $(autotools-package))
