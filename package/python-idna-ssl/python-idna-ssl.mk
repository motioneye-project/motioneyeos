################################################################################
#
# python-idna-ssl
#
################################################################################

PYTHON_IDNA_SSL_VERSION = 1.1.0
PYTHON_IDNA_SSL_SOURCE = idna-ssl-$(PYTHON_IDNA_VERSION).tar.gz
PYTHON_IDNA_SSL_SITE = https://files.pythonhosted.org/packages/46/03/07c4894aae38b0de52b52586b24bf189bb83e4ddabfe2e2c8f2419eec6f4
PYTHON_IDNA_SSL_LICENSE =  BSD-3-Clause
PYTHON_IDNA_SSL_LICENSE_FILES = LICENSE.rst
PYTHON_IDNA_SSL_SETUP_TYPE = setuptools

$(eval $(python-package))
