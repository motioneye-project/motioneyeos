################################################################################
#
# python-pytablewriter
#
################################################################################

PYTHON_PYTABLEWRITER_VERSION = 0.19.5
PYTHON_PYTABLEWRITER_SOURCE = pytablewriter-$(PYTHON_PYTABLEWRITER_VERSION).tar.gz
PYTHON_PYTABLEWRITER_SITE = https://pypi.python.org/packages/db/c6/517cb51aee3c83b7eb60353f818aab0f39d310c925ea103cc54c0e0f8cd2
PYTHON_PYTABLEWRITER_SETUP_TYPE = setuptools
PYTHON_PYTABLEWRITER_LICENSE = MIT
PYTHON_PYTABLEWRITER_LICENSE_FILES = LICENSE

$(eval $(python-package))
