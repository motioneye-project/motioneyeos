################################################################################
#
# bubblewrap
#
################################################################################

XDG_DBUS_PROXY_VERSION = 0.1.2
XDG_DBUS_PROXY_SITE = https://github.com/flatpak/xdg-dbus-proxy/releases/download/$(XDG_DBUS_PROXY_VERSION)
XDG_DBUS_PROXY_SOURCE = xdg-dbus-proxy-$(XDG_DBUS_PROXY_VERSION).tar.xz
XDG_DBUS_PROXY_DEPENDENCIES = host-pkgconf libglib2

XDG_DBUS_PROXY_LICENSE = LGPL-2.1+
XDG_DBUS_PROXY_LICENSE_FILES = COPYING

XDG_DBUS_PROXY_CONF_OPTS = --disable-man

$(eval $(autotools-package))
