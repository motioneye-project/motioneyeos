################################################################################
#
# python-channels
#
################################################################################

PYTHON_CHANNELS_VERSION = 2.2.0
PYTHON_CHANNELS_SOURCE = channels-$(PYTHON_CHANNELS_VERSION).tar.gz
PYTHON_CHANNELS_SITE = https://files.pythonhosted.org/packages/26/b9/92c803f3e8e304efbfbcd0634d4a5ad2d231f515b968f1b9e7c84ee78012
PYTHON_CHANNELS_SETUP_TYPE = setuptools
PYTHON_CHANNELS_LICENSE = BSD-3-Clause
PYTHON_CHANNELS_LICENSE_FILES = LICENSE

$(eval $(python-package))
