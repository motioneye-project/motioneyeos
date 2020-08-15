################################################################################
#
# python-crontab
#
################################################################################

PYTHON_CRONTAB_VERSION = 2.4.2
PYTHON_CRONTAB_SITE = https://files.pythonhosted.org/packages/d1/c2/e92e801a0c504e62899d574a6d281d6e598861797c6798a664556d2bca8c
PYTHON_CRONTAB_SETUP_TYPE = setuptools
PYTHON_CRONTAB_LICENSE = LGPL-3.0+
PYTHON_CRONTAB_LICENSE_FILES = COPYING

$(eval $(python-package))
