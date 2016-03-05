################################################################################
#
# net-tools
#
################################################################################

NET_TOOLS_VERSION = 3f170bff115303e92319791cbd56371e33dcbf6d
NET_TOOLS_SITE = git://git.code.sf.net/p/net-tools/code
NET_TOOLS_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
NET_TOOLS_LDFLAGS = $(TARGET_LDFLAGS) \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),-lintl)
NET_TOOLS_LICENSE = GPLv2+
NET_TOOLS_LICENSE_FILES = COPYING

# Install after busybox for the full-blown versions
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
NET_TOOLS_DEPENDENCIES += busybox
endif

define NET_TOOLS_CONFIGURE_CMDS
	(cd $(@D); yes "" | ./configure.sh config.in )
endef

# Enable I18N when appropiate
ifeq ($(BR2_ENABLE_LOCALE),y)
define NET_TOOLS_ENABLE_I18N
	$(SED) 's:I18N 0:I18N 1:' $(@D)/config.h
endef
endif

# Enable IPv6
define NET_TOOLS_ENABLE_IPV6
	$(SED) 's:_AFINET6 0:_AFINET6 1:' $(@D)/config.h
endef

NET_TOOLS_POST_CONFIGURE_HOOKS += NET_TOOLS_ENABLE_I18N NET_TOOLS_ENABLE_IPV6

define NET_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) AR="$(TARGET_AR)" CC="$(TARGET_CC)" \
		LDFLAGS="$(NET_TOOLS_LDFLAGS)" $(MAKE) -C $(@D)
endef

# install renames conflicting binaries, update does not
# ifconfig & route reside in /sbin for busybox
define NET_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) update
	mv -f $(TARGET_DIR)/bin/ifconfig $(TARGET_DIR)/sbin/ifconfig
	mv -f $(TARGET_DIR)/bin/route $(TARGET_DIR)/sbin/route
endef

$(eval $(generic-package))
