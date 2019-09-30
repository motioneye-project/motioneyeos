################################################################################
#
# python-simpleaudio
#
################################################################################

PYTHON_SIMPLEAUDIO_VERSION = 1.0.2
PYTHON_SIMPLEAUDIO_SOURCE = simpleaudio-$(PYTHON_SIMPLEAUDIO_VERSION).tar.gz
PYTHON_SIMPLEAUDIO_SITE = https://files.pythonhosted.org/packages/ad/39/ce09ef827887cdfc755427195d7291446c1fb34a16356d1fec920d62269d
PYTHON_SIMPLEAUDIO_LICENSE = MIT
PYTHON_SIMPLEAUDIO_LICENSE_FILES = LICENSE.txt
PYTHON_SIMPLEAUDIO_SETUP_TYPE = setuptools
PYTHON_SIMPLEAUDIO_DEPENDENCIES = alsa-lib

$(eval $(python-package))
