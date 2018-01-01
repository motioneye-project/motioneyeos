################################################################################
#
# python-alsaaudio
#
################################################################################

PYTHON_ALSAAUDIO_VERSION = 0.8.2
PYTHON_ALSAAUDIO_SOURCE = pyalsaaudio-$(PYTHON_ALSAAUDIO_VERSION).tar.gz
PYTHON_ALSAAUDIO_SITE = https://pypi.python.org/packages/source/p/pyalsaaudio
PYTHON_ALSAAUDIO_SETUP_TYPE = distutils
PYTHON_ALSAAUDIO_LICENSE = Python-2.0
PYTHON_ALSAAUDIO_LICENSE_FILES = LICENSE
PYTHON_ALSAAUDIO_DEPENDENCIES = alsa-lib

$(eval $(python-package))
