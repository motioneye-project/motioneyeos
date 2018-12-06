################################################################################
#
# python-aiojobs
#
################################################################################

PYTHON_AIOJOBS_VERSION = 0.2.2
PYTHON_AIOJOBS_SOURCE = aiojobs-$(PYTHON_AIOJOBS_VERSION).tar.gz
PYTHON_AIOJOBS_SITE = https://files.pythonhosted.org/packages/57/c5/9eb091930d6574002d1721dab5ca15a1bd69ed5dc8e654159d27223cdd3b
PYTHON_AIOJOBS_SETUP_TYPE = distutils
PYTHON_AIOJOBS_LICENSE = Apache-2.0
PYTHON_AIOJOBS_LICENSE_FILES = LICENSE

$(eval $(python-package))
