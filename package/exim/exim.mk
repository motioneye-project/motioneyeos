################################################################################
#
# exim
#
################################################################################

EXIM_VERSION = 4.82
EXIM_SOURCE = exim-$(EXIM_VERSION).tar.bz2
EXIM_SITE = ftp://ftp.exim.org/pub/exim/exim4
EXIM_LICENSE = GPLv2+
EXIM_LICENSE_FILES = LICENCE
EXIM_DEPENDENCIES = pcre berkeleydb

# Modify a variable value. It must already exist in the file, either
# commented or not.
define exim-config-change # variable-name, variable-value
	$(SED) 's,^[#[:space:]]*$1[[:space:]]*=.*$$,$1=$2,' \
		$(@D)/Local/Makefile
endef

# Comment-out a variable. Has no effect if it does not exits.
define exim-config-unset # variable-name
	$(SED) 's,^\([[:space:]]*$1[[:space:]]*=.*$$\),# \1,' \
		$(@D)/Local/Makefile
endef

# Add a variable definition. It must not already exist in the file,
# otherwise it would be defined twice with potentially different values.
define exim-config-add # variable-name, variable-value
	echo "$1=$2" >>$(@D)/Local/Makefile
endef

define EXIM_CONFIGURE_CMDS
	$(INSTALL) -m 0644 $(@D)/src/EDITME $(@D)/Local/Makefile
	$(call exim-config-change,BIN_DIRECTORY,/usr/sbin)
	$(call exim-config-change,CONFIGURE_FILE,/etc/exim/configure)
	$(call exim-config-change,EXIM_USER,ref:exim)
	$(call exim-config-change,EXIM_GROUP,mail)
	$(call exim-config-change,TRANSPORT_LMTP,yes)
	$(call exim-config-change,PCRE_LIBS,-lpcre)
	$(call exim-config-change,PCRE_CONFIG,no)
	$(call exim-config-change,HAVE_ICONV,no)
	$(call exim-config-unset,EXIM_MONITOR)
	$(call exim-config-add,CC,$(TARGET_CC))
	$(call exim-config-add,CFLAGS,$(TARGET_CFLAGS))
	$(call exim-config-add,AR,$(TARGET_AR) cq)
	$(call exim-config-add,RANLIB,$(TARGET_RANLIB))
	$(call exim-config-add,HOSTCC,$(HOSTCC))
	$(call exim-config-add,HOSTCFLAGS,$(HOSTCFLAGS))
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
