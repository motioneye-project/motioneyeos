################################################################################
#
# python-cheetah
#
################################################################################

PYTHON_CHEETAH_VERSION = 2.4.4
PYTHON_CHEETAH_SOURCE = Cheetah-$(PYTHON_CHEETAH_VERSION).tar.gz
PYTHON_CHEETAH_SITE = https://pypi.python.org/packages/source/C/Cheetah
PYTHON_CHEETAH_LICENSE = MIT
PYTHON_CHEETAH_SETUP_TYPE = setuptools

HOST_PYTHON_CHEETAH_NEEDS_HOST_PYTHON = python2

# The dependency on host-python-markdown is needed to prevent
# setuptools from downloading markdown if it is not installed yet.
HOST_PYTHON_CHEETAH_DEPENDENCIES = host-python-markdown

$(eval $(python-package))
$(eval $(host-python-package))
