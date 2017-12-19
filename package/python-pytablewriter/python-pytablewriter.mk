################################################################################
#
# python-pytablewriter
#
################################################################################

PYTHON_PYTABLEWRITER_VERSION = 0.24.0
PYTHON_PYTABLEWRITER_SOURCE = pytablewriter-$(PYTHON_PYTABLEWRITER_VERSION).tar.gz
PYTHON_PYTABLEWRITER_SITE = https://pypi.python.org/packages/65/b0/efafdd9e4d5b08069371530e46acde684ac7fb18bffa09b635e2af091d82
PYTHON_PYTABLEWRITER_SETUP_TYPE = setuptools
PYTHON_PYTABLEWRITER_LICENSE = MIT
PYTHON_PYTABLEWRITER_LICENSE_FILES = LICENSE

$(eval $(python-package))
