################################################################################
#
# python-m2r
#
################################################################################

PYTHON_M2R_VERSION = 0.1.12
PYTHON_M2R_SOURCE = m2r-$(PYTHON_M2R_VERSION).tar.gz
PYTHON_M2R_SITE = https://pypi.python.org/packages/a0/95/7273d54664e74c3100d07206fe6b30247be046b39676972fc90ae04376a1
PYTHON_M2R_SETUP_TYPE = setuptools
PYTHON_M2R_LICENSE = MIT
PYTHON_M2R_LICENSE_FILES = LICENSE
HOST_PYTHON_M2R_DEPENDENCIES = host-python-docutils host-python-mistune

$(eval $(python-package))
$(eval $(host-python-package))
