################################################################################
#
# python-pytablewriter
#
################################################################################

PYTHON_PYTABLEWRITER_VERSION = 0.19.8
PYTHON_PYTABLEWRITER_SOURCE = pytablewriter-$(PYTHON_PYTABLEWRITER_VERSION).tar.gz
PYTHON_PYTABLEWRITER_SITE = https://pypi.python.org/packages/9b/89/1883fcd076f40034539f577b033636b20d9a7983a8ba99e9b8ef11b680b2
PYTHON_PYTABLEWRITER_SETUP_TYPE = setuptools
PYTHON_PYTABLEWRITER_LICENSE = MIT
PYTHON_PYTABLEWRITER_LICENSE_FILES = LICENSE

$(eval $(python-package))
