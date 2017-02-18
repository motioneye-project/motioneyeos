################################################################################
#
# python-humanize
#
################################################################################

PYTHON_HUMANIZE_VERSION = 0.5.1
PYTHON_HUMANIZE_SOURCE = humanize-$(PYTHON_HUMANIZE_VERSION).tar.gz
PYTHON_HUMANIZE_SITE = https://pypi.python.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9
PYTHON_HUMANIZE_SETUP_TYPE = setuptools
PYTHON_HUMANIZE_LICENSE = MIT
PYTHON_HUMANIZE_LICENSE_FILES = LICENCE

$(eval $(python-package))
