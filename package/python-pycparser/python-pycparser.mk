################################################################################
#
# python-pycparser
#
################################################################################

PYTHON_PYCPARSER_VERSION = 2.17
PYTHON_PYCPARSER_SOURCE = pycparser-$(PYTHON_PYCPARSER_VERSION).tar.gz
PYTHON_PYCPARSER_SITE = https://pypi.python.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac
PYTHON_PYCPARSER_SETUP_TYPE = setuptools
PYTHON_PYCPARSER_LICENSE = BSD-3-Clause
PYTHON_PYCPARSER_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
