################################################################################
#
# python-pytablewriter
#
################################################################################

PYTHON_PYTABLEWRITER_VERSION = 0.17.2
PYTHON_PYTABLEWRITER_SOURCE = pytablewriter-$(PYTHON_PYTABLEWRITER_VERSION).tar.gz
PYTHON_PYTABLEWRITER_SITE = https://pypi.python.org/packages/47/5c/cbfed107164e56a6739d52694c4c584635970d6621b7e531464e89534956
PYTHON_PYTABLEWRITER_SETUP_TYPE = setuptools
PYTHON_PYTABLEWRITER_LICENSE = MIT
PYTHON_PYTABLEWRITER_LICENSE_FILES = LICENSE

$(eval $(python-package))
