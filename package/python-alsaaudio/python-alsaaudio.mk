################################################################################
#
# python-alsaaudio
#
################################################################################

PYTHON_ALSAAUDIO_VERSION = 0.7
PYTHON_ALSAAUDIO_SOURCE = pyalsaaudio-$(PYTHON_ALSAAUDIO_VERSION).tar.gz
PYTHON_ALSAAUDIO_SITE = http://downloads.sourceforge.net/project/pyalsaaudio
PYTHON_ALSAAUDIO_SETUP_TYPE = distutils
PYTHON_ALSAAUDIO_LICENSE = Python software foundation license v2
PYTHON_ALSAAUDIO_LICENSE_FILES = LICENSE
PYTHON_ALSAAUDIO_DEPENDENCIES = alsa-lib

$(eval $(python-package))
