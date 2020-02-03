################################################################################
#
# python-aioblescan
#
################################################################################

PYTHON_AIOBLESCAN_VERSION = 0.2.6
PYTHON_AIOBLESCAN_SOURCE = aioblescan-$(PYTHON_AIOBLESCAN_VERSION).tar.gz
PYTHON_AIOBLESCAN_SITE = https://files.pythonhosted.org/packages/66/b8/888c2eb4323ed498dbc7deeb8aee0cfec9edd8c25184b06a8874bb0cf84f
PYTHON_AIOBLESCAN_SETUP_TYPE = setuptools
PYTHON_AIOBLESCAN_LICENSE = MIT
PYTHON_AIOBLESCAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
