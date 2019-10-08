################################################################################
#
# python-channels
#
################################################################################

PYTHON_CHANNELS_VERSION = 2.3.0
PYTHON_CHANNELS_SOURCE = channels-$(PYTHON_CHANNELS_VERSION).tar.gz
PYTHON_CHANNELS_SITE = https://files.pythonhosted.org/packages/ad/69/fb21d6db9c4906a0e044812d15d99dcf2e98153dcf5bf2be48f833394670
PYTHON_CHANNELS_SETUP_TYPE = setuptools
PYTHON_CHANNELS_LICENSE = BSD-3-Clause
PYTHON_CHANNELS_LICENSE_FILES = LICENSE

$(eval $(python-package))
