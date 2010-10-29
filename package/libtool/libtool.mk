#############################################################
#
# libtool
#
#############################################################
LIBTOOL_VERSION = 2.2.10
LIBTOOL_SOURCE = libtool-$(LIBTOOL_VERSION).tar.gz
LIBTOOL_SITE = $(BR2_GNU_MIRROR)/libtool

define HOST_LIBTOOL_CUSTOM_INSTALL
	install -D -m 0644 $(HOST_DIR)/usr/share/aclocal/libtool.m4 \
		$(STAGING_DIR)/usr/share/aclocal/libtool.m4
	install -D -m 0644 $(HOST_DIR)/usr/share/aclocal/ltdl.m4 \
		$(STAGING_DIR)/usr/share/aclocal/ltdl.m4
endef

HOST_LIBTOOL_POST_INSTALL_HOOKS += HOST_LIBTOOL_CUSTOM_INSTALL

HOST_LIBTOOL_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,libtool))
$(eval $(call AUTOTARGETS,package,libtool,host))

# variables used by other packages
LIBTOOL:=$(HOST_DIR)/usr/bin/libtool
LIBTOOLIZE:=$(HOST_DIR)/usr/bin/libtoolize
