################################################################################
#
# python-pytablewriter
#
################################################################################

PYTHON_PYTABLEWRITER_VERSION = 0.5.0
PYTHON_PYTABLEWRITER_SOURCE = pytablewriter-$(PYTHON_PYTABLEWRITER_VERSION).tar.gz
PYTHON_PYTABLEWRITER_SITE = https://pypi.python.org/packages/c8/01/e4b7f1d83434d268fe6a0aec2d8ad00515de042285e58533090cfd72904d
PYTHON_PYTABLEWRITER_SETUP_TYPE = setuptools
PYTHON_PYTABLEWRITER_LICENSE = MIT
PYTHON_PYTABLEWRITER_LICENSE_FILES = LICENSE

$(eval $(python-package))
