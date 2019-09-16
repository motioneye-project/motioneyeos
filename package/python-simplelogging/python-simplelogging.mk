################################################################################
#
# python-simplelogging
#
################################################################################

PYTHON_SIMPLELOGGING_VERSION = 0.10.0
PYTHON_SIMPLELOGGING_SOURCE = simplelogging-$(PYTHON_SIMPLELOGGING_VERSION).tar.gz
PYTHON_SIMPLELOGGING_SITE = https://files.pythonhosted.org/packages/17/85/3d2431f971e703916c7254e4560ed15451faedf2461eb484da9e1ebc5da6
PYTHON_SIMPLELOGGING_SETUP_TYPE = setuptools
PYTHON_SIMPLELOGGING_LICENSE = BSD-3-Clause
PYTHON_SIMPLELOGGING_LICENSE_FILES = LICENSE

$(eval $(python-package))
