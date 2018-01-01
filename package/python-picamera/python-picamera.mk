################################################################################
#
# python-picamera
#
################################################################################

PYTHON_PICAMERA_VERSION = 1.13
PYTHON_PICAMERA_SOURCE = picamera-$(PYTHON_PICAMERA_VERSION).tar.gz
PYTHON_PICAMERA_SITE = https://pypi.python.org/packages/79/c4/80afe871d82ab1d5c9d8f0c0258228a8a0ed96db07a78ef17e7fba12fda8
PYTHON_PICAMERA_ENV = READTHEDOCS=True
                      
PYTHON_PICAMERA_SETUP_TYPE = distutils

$(eval $(python-package))

