################################################################################
#
# exim
#
################################################################################

EXIM_VERSION = 4.85
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

define EXIM_USE_CUSTOM_CONFIG_FILE
	$(INSTALL) -m 0644 $(BR2_PACKAGE_EXIM_CUSTOM_CONFIG_FILE) \
		$(@D)/Local/Makefile
endef

define EXIM_USE_DEFAULT_CONFIG_FILE
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
endef

ifeq ($(BR2_PACKAGE_DOVECOT),y)
EXIM_DEPENDENCIES += dovecot
define EXIM_USE_DEFAULT_CONFIG_FILE_DOVECOT
	$(call exim-config-change,AUTH_DOVECOT,yes)
endef
endif

ifeq ($(BR2_PACKAGE_CLAMAV),y)
EXIM_DEPENDENCIES += clamav
define EXIM_USE_DEFAULT_CONFIG_FILE_CLAMAV
	$(call exim-config-change,WITH_CONTENT_SCAN,yes)
endef
endif

define EXIM_CONFIGURE_TOOLCHAIN
	$(call exim-config-add,CC,$(TARGET_CC))
	$(call exim-config-add,CFLAGS,$(TARGET_CFLAGS))
	$(call exim-config-add,AR,$(TARGET_AR) cq)
	$(call exim-config-add,RANLIB,$(TARGET_RANLIB))
	$(call exim-config-add,HOSTCC,$(HOSTCC))
	$(call exim-config-add,HOSTCFLAGS,$(HOSTCFLAGS))
endef

ifneq ($(call qstrip,$(BR2_PACKAGE_EXIM_CUSTOM_CONFIG_FILE)),)
define EXIM_CONFIGURE_CMDS
	$(EXIM_USE_CUSTOM_CONFIG_FILE)
	$(EXIM_CONFIGURE_TOOLCHAIN)
endef
else # CUSTOM_CONFIG
define EXIM_CONFIGURE_CMDS
	$(EXIM_USE_DEFAULT_CONFIG_FILE)
	$(EXIM_USE_DEFAULT_CONFIG_FILE_DOVECOT)
	$(EXIM_USE_DEFAULT_CONFIG_FILE_CLAMAV)
	$(EXIM_CONFIGURE_TOOLCHAIN)
endef
endif # CUSTOM_CONFIG

# exim needs a bit of love to build statically
ifeq ($(BR2_STATIC_LIBS),y)
EXIM_STATIC_FLAGS = LFLAGS="-pthread --static"
endif

# "The -j (parallel) flag must not be used with make"
# (http://www.exim.org/exim-html-current/doc/html/spec_html/ch04.html)
define EXIM_BUILD_CMDS
	build=br $(MAKE1) -C $(@D) $(EXIM_STATIC_FLAGS)
endef

# Need to replicate the LFLAGS in install, as exim still wants to build
# something when installing...
define EXIM_INSTALL_TARGET_CMDS
	DESTDIR=$(TARGET_DIR) INSTALL_ARG="-no_chown -no_symlink" build=br \
	  $(MAKE1) -C $(@D) $(EXIM_STATIC_FLAGS) install
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
