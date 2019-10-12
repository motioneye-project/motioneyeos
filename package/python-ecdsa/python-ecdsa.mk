################################################################################
#
# python-ecdsa
#
################################################################################

PYTHON_ECDSA_VERSION = 0.13.3
PYTHON_ECDSA_SOURCE = ecdsa-$(PYTHON_ECDSA_VERSION).tar.gz
PYTHON_ECDSA_SITE = https://files.pythonhosted.org/packages/8c/d8/9c3596fd0f18ae0a76333492a119c00183323d8e64de1a4f4bd642856963
PYTHON_ECDSA_SETUP_TYPE = setuptools
PYTHON_ECDSA_LICENSE = MIT
PYTHON_ECDSA_LICENSE_FILES = LICENSE

$(eval $(python-package))
