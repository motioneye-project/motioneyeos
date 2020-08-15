################################################################################
#
# python-simpleaudio
#
################################################################################

PYTHON_SIMPLEAUDIO_VERSION = 1.0.4
PYTHON_SIMPLEAUDIO_SOURCE = simpleaudio-$(PYTHON_SIMPLEAUDIO_VERSION).tar.gz
PYTHON_SIMPLEAUDIO_SITE = https://files.pythonhosted.org/packages/94/1b/4dc29653733202b68c09d9c6ca085cf67ac54859ee860647ef21ac1ff3dc
PYTHON_SIMPLEAUDIO_LICENSE = MIT
PYTHON_SIMPLEAUDIO_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEAUDIO_SETUP_TYPE = setuptools
PYTHON_SIMPLEAUDIO_DEPENDENCIES = alsa-lib

$(eval $(python-package))
