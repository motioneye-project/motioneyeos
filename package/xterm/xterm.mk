#############################################################
#
# xterm
#
#############################################################

XTERM_VERSION:=262
XTERM_SOURCE:=xterm-$(XTERM_VERSION).tgz
XTERM_SITE:=ftp://invisible-island.net/xterm
XTERM_DEPENDENCIES = xserver_xorg-server xlib_libXaw
XTERM_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package,xterm))
