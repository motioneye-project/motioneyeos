################################################################################
#
# python-logbook
#
################################################################################

PYTHON_LOGBOOK_VERSION = 1.4.3
PYTHON_LOGBOOK_SOURCE = Logbook-$(PYTHON_LOGBOOK_VERSION).tar.gz
PYTHON_LOGBOOK_SITE = https://files.pythonhosted.org/packages/f6/83/20fc0270614919cb799f76e32cf143a54c58ce2fa45c19fd38ac2e4f9977
PYTHON_LOGBOOK_SETUP_TYPE = setuptools
PYTHON_LOGBOOK_LICENSE = BSD-3-Clause
PYTHON_LOGBOOK_LICENSE_FILES = LICENSE

$(eval $(python-package))
