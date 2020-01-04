################################################################################
#
# python-pyalsa
#
################################################################################

PYTHON_PYALSA_VERSION = 1.1.6
PYTHON_PYALSA_SOURCE = pyalsa-$(PYTHON_PYALSA_VERSION).tar.bz2
PYTHON_PYALSA_SITE = ftp://ftp.alsa-project.org/pub/pyalsa
PYTHON_PYALSA_SETUP_TYPE = distutils
PYTHON_PYALSA_LICENSE = LGPL-2.1+
PYTHON_PYALSA_DEPENDENCIES = alsa-lib

$(eval $(python-package))
