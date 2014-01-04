################################################################################
#
# xcb-proto
#
################################################################################

XCB_PROTO_VERSION = 1.10
XCB_PROTO_SOURCE = xcb-proto-$(XCB_PROTO_VERSION).tar.bz2
XCB_PROTO_SITE = http://xcb.freedesktop.org/dist/
XCB_PROTO_LICENSE = MIT
XCB_PROTO_LICENSE_FILES = COPYING

XCB_PROTO_INSTALL_STAGING = YES

XCB_PROTO_DEPENDENCIES = host-python

# xcbincludedir/pythondir is used by E.G. libxcb at build time to find the
# xml / python files, so ensure these expand to their full (host) paths
define XCB_PROTO_FIXUP_PC_FILE
	$(SED) 's|^\(xcbincludedir=\)|\1$(STAGING_DIR)|' \
	    -e 's|^\(pythondir=\)|\1$(STAGING_DIR)|' \
		$(STAGING_DIR)/usr/lib/pkgconfig/xcb-proto.pc
endef

XCB_PROTO_POST_INSTALL_STAGING_HOOKS += XCB_PROTO_FIXUP_PC_FILE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
