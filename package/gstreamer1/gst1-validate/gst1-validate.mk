################################################################################
#
# gst1-validate
#
################################################################################

GST1_VALIDATE_VERSION = 1.8.1
GST1_VALIDATE_SOURCE = gst-validate-$(GST1_VALIDATE_VERSION).tar.xz
GST1_VALIDATE_SITE = http://gstreamer.freedesktop.org/src/gst-validate
GST1_VALIDATE_LICENSE = LGPLv2.1+
GST1_VALIDATE_LICENSE_FILES = COPYING

GST1_VALIDATE_CONF_OPTS = --disable-sphinx-doc

GST1_VALIDATE_DEPENDENCIES = \
	gstreamer1 \
	gst1-plugins-base \
	host-python \
	python \
	$(if $(BR2_PACKAGE_CAIRO),cairo)

$(eval $(autotools-package))
