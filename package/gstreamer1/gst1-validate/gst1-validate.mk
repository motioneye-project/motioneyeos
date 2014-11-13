################################################################################
#
# gst1-validate
#
################################################################################

GST1_VALIDATE_VERSION = 1.4.0
GST1_VALIDATE_SOURCE = gst-validate-$(GST1_VALIDATE_VERSION).tar.xz
GST1_VALIDATE_SITE = http://gstreamer.freedesktop.org/src/gst-validate
GST1_VALIDATE_LICENSE = LGPLv2.1+
GST1_VALIDATE_LICENSE_FILES = COPYING

GST1_VALIDATE_CONF_OPTS = --disable-sphinx-doc

GST1_VALIDATE_DEPENDENCIES = gstreamer1 gst1-plugins-base host-python python

$(eval $(autotools-package))
