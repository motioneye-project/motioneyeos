#############################################################
#
# python-simpleaudio
#
#############################################################

PYTHON_SIMPLEAUDIO_VERSION = 1.0.1
PYTHON_SIMPLEAUDIO_SOURCE = simpleaudio-$(PYTHON_SIMPLEAUDIO_VERSION).tar.gz
PYTHON_SIMPLEAUDIO_SITE = https://pypi.python.org/packages/12/f6/327c1af94062a6a6a5ff06dcf9dc689ed81aa07ae757cca3438c3c9e50fe
PYTHON_SIMPLEAUDIO_LICENSE = MIT
PYTHON_SIMPLEAUDIO_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEAUDIO_SETUP_TYPE = setuptools
PYTHON_SIMPLEAUDIO_DEPENDENCIES = alsa-lib

$(eval $(python-package))
