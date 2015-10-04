################################################################################
#
# python-picamera
#
################################################################################

PYTHON_PICAMERA_VERSION = 1.10
PYTHON_PICAMERA_SOURCE = picamera-$(PYTHON_PICAMERA_VERSION).tar.gz
PYTHON_PICAMERA_SITE = http://pypi.python.org/packages/source/p/picamera
PYTHON_PICAMERA_SETUP_TYPE = distutils

$(eval $(python-package))
