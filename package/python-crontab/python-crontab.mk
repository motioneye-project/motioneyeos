################################################################################
#
# python-crontab
#
################################################################################

PYTHON_CRONTAB_VERSION = 2.4.1
PYTHON_CRONTAB_SITE = https://files.pythonhosted.org/packages/09/b1/31d3ccf2ad3d4f7727b325ad7ea77d042e1939c5cacbf1d7478e391cca51
PYTHON_CRONTAB_SETUP_TYPE = setuptools
PYTHON_CRONTAB_LICENSE = LGPL-3.0+
PYTHON_CRONTAB_LICENSE_FILES = COPYING

$(eval $(python-package))
