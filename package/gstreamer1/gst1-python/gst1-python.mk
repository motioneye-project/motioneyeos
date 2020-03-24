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

# Due to the CONF_ENV options, libpython-dir must be set manually
# or else the error: "Python dynamic library path could not be determined"
# occurs. We set the libpython-dir to /usr/lib as this path is hard-coded
# into the resulting .so file as /usr/lib/python3.$(PYTHON3_VERSION_MAJOR).so.
# Because we provide PYTHONPATH=$(PYTHON3_PATH) above, the logic in the meson
# file uses the above python path to determine if /usr/lib/ has the proper .so
# file. Because Buildroot provides the appropriate paths, the meson file finds
# the correct .so file, and the resulting compiled library has the appropriate
# path of /usr/lib/python3.$(PYTHON3_VERSION_MAJOR).so
GST1_PYTHON_CONF_OPTS += \
	-Dlibpython-dir=/usr/lib/

$(eval $(meson-package))
