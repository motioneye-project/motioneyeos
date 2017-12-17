################################################################################
#
# python-priority
#
################################################################################

PYTHON_PRIORITY_VERSION = 1.3.0
PYTHON_PRIORITY_SOURCE = priority-$(PYTHON_PRIORITY_VERSION).tar.gz
PYTHON_PRIORITY_SITE = https://pypi.python.org/packages/ba/96/7d0b024087062418dfe02a68cd6b195399266ac002fb517aad94cc93e076
PYTHON_PRIORITY_SETUP_TYPE = setuptools
PYTHON_PRIORITY_LICENSE = MIT
PYTHON_PRIORITY_LICENSE_FILES = LICENSE

$(eval $(python-package))
