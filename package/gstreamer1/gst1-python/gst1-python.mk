################################################################################
#
# gst1-python
#
################################################################################

GST1_PYTHON_VERSION = 1.16.2
GST1_PYTHON_SOURCE = gst-python-$(GST1_PYTHON_VERSION).tar.xz
GST1_PYTHON_SITE = https://gstreamer.freedesktop.org/src/gst-python
GST1_PYTHON_INSTALL_STAGING = YES
GST1_PYTHON_LICENSE_FILES = COPYING
GST1_PYTHON_LICENSE = LGPL-2.1+

GST1_PYTHON_DEPENDENCIES = \
	gstreamer1 \
	python-gobject

# A sysconfigdata_name must be manually specified or the resulting .so
# will have a x86_64 prefix, which causes "from gi.repository import Gst"
# to fail. A pythonpath must be specified or the host python path will be
# used resulting in a "not a valid python" error.
GST1_PYTHON_CONF_ENV += \
	_PYTHON_SYSCONFIGDATA_NAME=$(PKG_PYTHON_SYSCONFIGDATA_NAME) \
	PYTHONPATH=$(PYTHON3_PATH)

# Due to the CONF_ENV options, libpython-dir must be set to the host directory
# or else the error: "Python dynamic library path could not be determined"
# will occure
GST1_PYTHON_CONF_OPTS += \
	-Dlibpython-dir=$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)

$(eval $(meson-package))
