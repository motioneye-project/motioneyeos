################################################################################
#
# python-tqdm
#
################################################################################

PYTHON_TQDM_VERSION = 4.37.0
PYTHON_TQDM_SOURCE = tqdm-$(PYTHON_TQDM_VERSION).tar.gz
PYTHON_TQDM_SITE = https://files.pythonhosted.org/packages/cc/7b/5878d4e1b01a2eb802f78ea277f2385072681cabefc8fb4fbdee28dd1869
PYTHON_TQDM_SETUP_TYPE = setuptools
PYTHON_TQDM_LICENSE = MPL-2.0, MIT
PYTHON_TQDM_LICENSE_FILES = LICENCE

$(eval $(python-package))
