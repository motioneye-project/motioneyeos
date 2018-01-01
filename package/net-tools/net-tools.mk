################################################################################
#
# net-tools
#
################################################################################

NET_TOOLS_VERSION = 479bb4a7e11a4084e2935c0a576388f92469225b
NET_TOOLS_SITE = git://git.code.sf.net/p/net-tools/code
NET_TOOLS_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
NET_TOOLS_LICENSE = GPL-2.0+
NET_TOOLS_LICENSE_FILES = COPYING

# Install after busybox for the full-blown versions
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
NET_TOOLS_DEPENDENCIES += busybox
endif

define NET_TOOLS_CONFIGURE_CMDS
	(cd $(@D); yes "" | ./configure.sh config.in )
endef

# Enable I18N when appropiate
ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
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
	$(TARGET_CONFIGURE_OPTS) \
		LDFLAGS="$(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)" \
		$(MAKE) -C $(@D)
endef

# install renames conflicting binaries, update does not
# ifconfig & route reside in /sbin for busybox
define NET_TOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) update
	mv -f $(TARGET_DIR)/bin/ifconfig $(TARGET_DIR)/sbin/ifconfig
	mv -f $(TARGET_DIR)/bin/route $(TARGET_DIR)/sbin/route
endef

$(eval $(generic-package))
