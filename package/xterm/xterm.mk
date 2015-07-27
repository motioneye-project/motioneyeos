################################################################################
#
# xterm
#
################################################################################

XTERM_VERSION = 314
XTERM_SOURCE = xterm-$(XTERM_VERSION).tgz
XTERM_SITE = ftp://invisible-island.net/xterm
XTERM_DEPENDENCIES = ncurses xlib_libXaw
XTERM_LICENSE = MIT
XTERM_LICENSE_FILES = version.c
XTERM_CONF_OPTS = --enable-256-color \
	--x-includes=$(STAGING_DIR)/usr/include \
	--x-libraries=$(STAGING_DIR)/usr/lib

$(eval $(autotools-package))
