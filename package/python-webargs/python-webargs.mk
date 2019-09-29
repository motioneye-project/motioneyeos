################################################################################
#
# python-webargs
#
################################################################################

PYTHON_WEBARGS_VERSION = 5.3.1
PYTHON_WEBARGS_SOURCE = webargs-$(PYTHON_WEBARGS_VERSION).tar.gz
PYTHON_WEBARGS_SITE = https://files.pythonhosted.org/packages/b2/df/156e105358c06b6f76a17cb3ee3eb82789a3abbc482a5a2f8b576e81112c
PYTHON_WEBARGS_SETUP_TYPE = setuptools
PYTHON_WEBARGS_LICENSE = Apache-2.0
PYTHON_WEBARGS_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
