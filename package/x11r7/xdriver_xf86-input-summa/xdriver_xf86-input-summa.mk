################################################################################
#
# xdriver_xf86-input-summa -- X.Org driver for summa input devices
#
################################################################################

XDRIVER_XF86_INPUT_SUMMA_VERSION = 1.2.0
XDRIVER_XF86_INPUT_SUMMA_SOURCE = xf86-input-summa-$(XDRIVER_XF86_INPUT_SUMMA_VERSION).tar.bz2
XDRIVER_XF86_INPUT_SUMMA_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_INPUT_SUMMA_AUTORECONF = NO
XDRIVER_XF86_INPUT_SUMMA_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_SUMMA_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-summa))
