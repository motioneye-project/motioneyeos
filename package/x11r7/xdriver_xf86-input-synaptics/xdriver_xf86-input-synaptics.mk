################################################################################
#
# xdriver_xf86-input-synaptics -- X.Org driver for synaptics input devices
#
################################################################################

XDRIVER_XF86_INPUT_SYNAPTICS_VERSION = 0.14.7~git20070706
XDRIVER_XF86_INPUT_SYNAPTICS_SOURCE = xfree86-driver-synaptics_$(XDRIVER_XF86_INPUT_SYNAPTICS_VERSION).orig.tar.gz
XDRIVER_XF86_INPUT_SYNAPTICS_SITE = http://ftp.de.debian.org/debian/pool/main/x/xfree86-driver-synaptics
XDRIVER_XF86_INPUT_SYNAPTICS_AUTORECONF = NO
XDRIVER_XF86_INPUT_SYNAPTICS_DEPENDENCIES = xserver_xorg-server xproto_inputproto xproto_randrproto xproto_xproto
XDRIVER_XF86_INPUT_SYNAPTICS_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

$(eval $(call AUTOTARGETS,package/x11r7,xdriver_xf86-input-synaptics))
