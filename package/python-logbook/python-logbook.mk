################################################################################
#
# python-logbook
#
################################################################################

PYTHON_LOGBOOK_VERSION = 1.5.2
PYTHON_LOGBOOK_SOURCE = Logbook-$(PYTHON_LOGBOOK_VERSION).tar.gz
PYTHON_LOGBOOK_SITE = https://files.pythonhosted.org/packages/6b/3f/f4e6693791efacc1282852fba5392da0649b19416b37422c5489f79a52ea
PYTHON_LOGBOOK_SETUP_TYPE = setuptools
PYTHON_LOGBOOK_LICENSE = BSD-3-Clause
PYTHON_LOGBOOK_LICENSE_FILES = LICENSE

$(eval $(python-package))
