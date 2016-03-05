################################################################################
#
# proftpd
#
################################################################################

PROFTPD_VERSION = 1.3.5a
PROFTPD_SOURCE = proftpd-$(PROFTPD_VERSION).tar.gz
PROFTPD_SITE = ftp://ftp.proftpd.org/distrib/source
PROFTPD_LICENSE = GPLv2+
PROFTPD_LICENSE_FILES = COPYING

PROFTPD_CONF_ENV = \
	ac_cv_func_setpgrp_void=yes \
	ac_cv_func_setgrent_void=yes

PROFTPD_CONF_OPTS = \
	--localstatedir=/var/run \
	--disable-static \
	--disable-curses \
	--disable-ncurses \
	--disable-facl \
	--disable-dso \
	--enable-shadow \
	--with-gnu-ld

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_REWRITE),y)
PROFTPD_CONF_OPTS += --with-modules=mod_rewrite
endif

# configure script doesn't handle detection of %llu format string
# support for printing the file size when cross compiling, breaking
# access for large files.
# We unfortunately cannot AUTORECONF the package, so instead force it
# on if we know we support it
define PROFTPD_USE_LLU
	$(SED) 's/HAVE_LU/HAVE_LLU/' $(@D)/configure
endef
PROFTPD_PRE_CONFIGURE_HOOKS += PROFTPD_USE_LLU

define PROFTPD_MAKENAMES
	$(MAKE1) CC="$(HOSTCC)" CFLAGS="" LDFLAGS="" -C $(@D)/lib/libcap _makenames
endef

PROFTPD_POST_CONFIGURE_HOOKS = PROFTPD_MAKENAMES

PROFTPD_MAKE = $(MAKE1)

define PROFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/proftpd $(TARGET_DIR)/usr/sbin/proftpd
	$(INSTALL) -m 0644 -D $(@D)/sample-configurations/basic.conf $(TARGET_DIR)/etc/proftpd.conf
endef

define PROFTPD_USERS
	ftp -1 ftp -1 * /home/ftp - - Anonymous FTP User
endef

define PROFTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/proftpd/S50proftpd $(TARGET_DIR)/etc/init.d/S50proftpd
endef

define PROFTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/proftpd/proftpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/proftpd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/proftpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/proftpd.service
endef

$(eval $(autotools-package))
