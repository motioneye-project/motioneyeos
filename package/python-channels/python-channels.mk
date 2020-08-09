################################################################################
#
# python-channels
#
################################################################################

PYTHON_CHANNELS_VERSION = 2.3.1
PYTHON_CHANNELS_SOURCE = channels-$(PYTHON_CHANNELS_VERSION).tar.gz
PYTHON_CHANNELS_SITE = https://files.pythonhosted.org/packages/75/53/2db9662a52dcedb02a25f87d8efc5e630059967790e4c10887dbd2db2073
PYTHON_CHANNELS_SETUP_TYPE = setuptools
PYTHON_CHANNELS_LICENSE = BSD-3-Clause
PYTHON_CHANNELS_LICENSE_FILES = LICENSE

$(eval $(python-package))
