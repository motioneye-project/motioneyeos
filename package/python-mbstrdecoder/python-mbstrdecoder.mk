################################################################################
#
# python-mbstrdecoder
#
################################################################################

PYTHON_MBSTRDECODER_VERSION = 0.8.1
PYTHON_MBSTRDECODER_SOURCE = mbstrdecoder-$(PYTHON_MBSTRDECODER_VERSION).tar.gz
PYTHON_MBSTRDECODER_SITE = https://files.pythonhosted.org/packages/fd/0f/11982e1321f484b5ec85bb3e03878c9636ca5328fbcbed8b25ecbd76fd44
PYTHON_MBSTRDECODER_SETUP_TYPE = setuptools
PYTHON_MBSTRDECODER_LICENSE = MIT
PYTHON_MBSTRDECODER_LICENSE_FILES = LICENSE

$(eval $(python-package))
