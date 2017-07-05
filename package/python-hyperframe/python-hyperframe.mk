################################################################################
#
# python-hyperframe
#
################################################################################

PYTHON_HYPERFRAME_VERSION = 5.1.0
PYTHON_HYPERFRAME_SOURCE = hyperframe-$(PYTHON_HYPERFRAME_VERSION).tar.gz
PYTHON_HYPERFRAME_SITE = https://pypi.python.org/packages/a4/59/dddaddc73b4d53e9649850998e23b6daca80817c5442465a12423235d20b
PYTHON_HYPERFRAME_SETUP_TYPE = setuptools
PYTHON_HYPERFRAME_LICENSE = MIT
PYTHON_HYPERFRAME_LICENSE_FILES = LICENSE

$(eval $(python-package))
