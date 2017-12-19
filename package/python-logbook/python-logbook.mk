################################################################################
#
# python-logbook
#
################################################################################

PYTHON_LOGBOOK_VERSION = 1.0.0
PYTHON_LOGBOOK_SOURCE = Logbook-$(PYTHON_LOGBOOK_VERSION).tar.gz
PYTHON_LOGBOOK_SITE = https://pypi.python.org/packages/34/e8/6419c217bbf464fe8a902418120cccaf476201bd03b50958db24d6e90f65
PYTHON_LOGBOOK_SETUP_TYPE = setuptools
PYTHON_LOGBOOK_LICENSE = BSD-3-Clause

$(eval $(python-package))
