################################################################################
#
# python-subprocess32
#
################################################################################

PYTHON_SUBPROCESS32_VERSION = 3.2.7
PYTHON_SUBPROCESS32_SOURCE = subprocess32-$(PYTHON_SUBPROCESS32_VERSION).tar.gz
PYTHON_SUBPROCESS32_SITE = https://files.pythonhosted.org/packages/b8/2f/49e53b0d0e94611a2dc624a1ad24d41b6d94d0f1b0a078443407ea2214c2
PYTHON_SUBPROCESS32_SETUP_TYPE = distutils
PYTHON_SUBPROCESS32_LICENSE = Python-2.0
PYTHON_SUBPROCESS32_LICENSE_FILES = LICENSE

$(eval $(python-package))
