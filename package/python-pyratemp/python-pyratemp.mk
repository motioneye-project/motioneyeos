################################################################################
#
# python-pyratemp
#
################################################################################

PYTHON_PYRATEMP_VERSION = 0.3.2
PYTHON_PYRATEMP_SOURCE = pyratemp-$(PYTHON_PYRATEMP_VERSION).tgz
PYTHON_PYRATEMP_SITE = https://pypi.python.org/packages/source/p/pyratemp
PYTHON_PYRATEMP_LICENSE = MIT
PYTHON_PYRATEMP_LICENSE_FILES = LICENSE
PYTHON_PYRATEMP_SETUP_TYPE = distutils

$(eval $(python-package))
