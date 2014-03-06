#############################################################
#
# exim
#
#############################################################

EXIM_VERSION = 4.82
EXIM_SOURCE = exim-$(EXIM_VERSION).tar.bz2
EXIM_SITE = ftp://ftp.exim.org/pub/exim/exim4
EXIM_LICENSE = GPLv2+
EXIM_LICENSE_FILES = LICENCE
EXIM_DEPENDENCIES = pcre berkeleydb

# These echos seem to be the sanest way to feed CC and CFLAGS to exim
define EXIM_CONFIGURE_CMDS
	$(INSTALL) -m 0644 -D package/exim/Local-Makefile $(@D)/Local/Makefile
	echo "CC=$(TARGET_CC)" >>$(@D)/Local/Makefile
	echo "CFLAGS=$(TARGET_CFLAGS)" >>$(@D)/Local/Makefile
	echo "AR=$(TARGET_AR) cq" >>$(@D)/Local/Makefile
	echo "RANLIB=$(TARGET_RANLIB)" >>$(@D)/Local/Makefile
	echo "HOSTCC=$(HOSTCC)" >>$(@D)/Local/Makefile
	echo "HOSTCFLAGS=$(HOSTCFLAGS)" >>$(@D)/Local/Makefile
endef

# "The -j (parallel) flag must not be used with make"
# (http://www.exim.org/exim-html-current/doc/html/spec_html/ch04.html)
define EXIM_BUILD_CMDS
	build=br $(MAKE1) -C $(@D)
endef

define EXIM_INSTALL_TARGET_CMDS
	DESTDIR=$(TARGET_DIR) INSTALL_ARG="-no_chown -no_symlink" build=br \
	  $(MAKE1) -C $(@D) install
	chmod u+s $(TARGET_DIR)/usr/sbin/exim
endef

define EXIM_USERS
exim 88 mail 8 * - - - exim
endef

define EXIM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/exim/S86exim \
		$(TARGET_DIR)/etc/init.d/S86exim
endef

$(eval $(generic-package))
