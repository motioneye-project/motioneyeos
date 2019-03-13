################################################################################
#
# python-aioblescan
#
################################################################################

PYTHON_AIOBLESCAN_VERSION = 0.2.4
PYTHON_AIOBLESCAN_SOURCE = aioblescan-$(PYTHON_AIOBLESCAN_VERSION).tar.gz
PYTHON_AIOBLESCAN_SITE = https://files.pythonhosted.org/packages/a9/ad/1e2f41b2036bd76079f88cd94ce35b5a996d937dccaf432ea6b8092d3e11
PYTHON_AIOBLESCAN_SETUP_TYPE = distutils
PYTHON_AIOBLESCAN_LICENSE = MIT
PYTHON_AIOBLESCAN_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
