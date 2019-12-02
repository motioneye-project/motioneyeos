################################################################################
#
# python-crontab
#
################################################################################

PYTHON_CRONTAB_VERSION = 2.4.0
PYTHON_CRONTAB_SITE = https://files.pythonhosted.org/packages/bc/03/852f9c5f8da7f58abce06fe8ae769cbcf6502f1c60684b16bad72ffcced3
PYTHON_CRONTAB_SETUP_TYPE = setuptools
PYTHON_CRONTAB_LICENSE = LGPL-3.0+
PYTHON_CRONTAB_LICENSE_FILES = COPYING

$(eval $(python-package))
