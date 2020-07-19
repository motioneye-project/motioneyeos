################################################################################
#
# exim
#
################################################################################

EXIM_VERSION = 4.93.0.4
EXIM_SOURCE = exim-$(EXIM_VERSION).tar.xz
EXIM_SITE = https://ftp.exim.org/pub/exim/exim4/fixes
EXIM_LICENSE = GPL-2.0+
EXIM_LICENSE_FILES = LICENCE
EXIM_DEPENDENCIES = host-berkeleydb host-pcre pcre berkeleydb host-pkgconf

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
	$(call exim-config-change,LOG_FILE_PATH,/var/log/exim/exim_%slog)
	$(call exim-config-change,PID_FILE_PATH,/var/run/exim/exim.pid)
	$(call exim-config-change,EXIM_USER,ref:exim)
	$(call exim-config-change,EXIM_GROUP,mail)
	$(call exim-config-change,TRANSPORT_LMTP,yes)
	$(call exim-config-change,PCRE_LIBS,-lpcre)
	$(call exim-config-change,PCRE_CONFIG,no)
	$(call exim-config-change,HAVE_ICONV,no)
	$(call exim-config-unset,EXIM_MONITOR)
	$(call exim-config-change,AUTH_PLAINTEXT,yes)
	$(call exim-config-change,AUTH_CRAM_MD5,yes)
	$(call exim-config-unset,SUPPORT_DANE)
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

ifeq ($(BR2_PACKAGE_OPENSSL),y)
EXIM_DEPENDENCIES += host-openssl openssl
define EXIM_USE_DEFAULT_CONFIG_FILE_OPENSSL
	$(call exim-config-change,USE_OPENSSL,yes)
	$(call exim-config-change,USE_OPENSSL_PC,openssl)
endef
else
define EXIM_USE_DEFAULT_CONFIG_FILE_OPENSSL
	$(call exim-config-change,DISABLE_TLS,yes)
endef
endif

# musl does not provide struct ip_options nor struct ip_opts (but it is
# available with both glibc and uClibc)
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
define EXIM_FIX_IP_OPTIONS_FOR_MUSL
	$(SED) 's/#define GLIBC_IP_OPTIONS/#define DARWIN_IP_OPTIONS/' \
		$(@D)/OS/os.h-Linux
endef
endif

define EXIM_CONFIGURE_TOOLCHAIN
	$(call exim-config-add,CC,$(TARGET_CC))
	$(call exim-config-add,CFLAGS,$(TARGET_CFLAGS))
	$(call exim-config-add,AR,$(TARGET_AR) cq)
	$(call exim-config-add,RANLIB,$(TARGET_RANLIB))
	$(call exim-config-add,HOSTCC,$(HOSTCC))
	$(call exim-config-add,HOSTCFLAGS,$(HOSTCFLAGS))
	$(EXIM_FIX_IP_OPTIONS_FOR_MUSL)
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
	$(EXIM_USE_DEFAULT_CONFIG_FILE_OPENSSL)
	$(EXIM_CONFIGURE_TOOLCHAIN)
endef
endif # CUSTOM_CONFIG

# exim needs a bit of love to build statically
ifeq ($(BR2_STATIC_LIBS),y)
EXIM_STATIC_FLAGS = LFLAGS="-pthread --static"
endif

# We need the host version of macro_predef during the build, before
# building it we need to prepare the makefile.
define EXIM_BUILD_CMDS
	$(TARGET_MAKE_ENV) build=br $(MAKE) -C $(@D) makefile
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/build-br macro_predef \
		CC="$(HOSTCC)" \
		LNCC="$(HOSTCC)" \
		CFLAGS="-std=c99 $(HOST_CFLAGS)" \
		LFLAGS="-fPIC $(HOST_LDFLAGS)"
	$(TARGET_MAKE_ENV) build=br $(MAKE) -C $(@D) $(EXIM_STATIC_FLAGS) \
		CFLAGS="-std=c99 $(TARGET_CFLAGS)"
endef

# Need to replicate the LFLAGS in install, as exim still wants to build
# something when installing...
define EXIM_INSTALL_TARGET_CMDS
	DESTDIR=$(TARGET_DIR) INSTALL_ARG="-no_chown -no_symlink" build=br \
	  $(MAKE) -C $(@D) $(EXIM_STATIC_FLAGS) \
		CFLAGS="-std=c99 $(TARGET_CFLAGS)" \
		install
	chmod u+s $(TARGET_DIR)/usr/sbin/exim
endef

define EXIM_USERS
	exim 88 mail 8 * - - - exim
endef

define EXIM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/exim/S86exim \
		$(TARGET_DIR)/etc/init.d/S86exim
endef

define EXIM_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/exim/exim.service \
		$(TARGET_DIR)/usr/lib/systemd/system/exim.service
endef

$(eval $(generic-package))
