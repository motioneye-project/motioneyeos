################################################################################
#
# python-m2r
#
################################################################################

PYTHON_M2R_VERSION = 0.1.6
PYTHON_M2R_SOURCE = m2r-$(PYTHON_M2R_VERSION).tar.gz
PYTHON_M2R_SITE = https://pypi.python.org/packages/8d/74/558f9aba132bb34cd661fad9e17d42bfa1332363466ff314e600096f78c3
PYTHON_M2R_SETUP_TYPE = setuptools
PYTHON_M2R_LICENSE = MIT
PYTHON_M2R_LICENSE_FILES = LICENSE
HOST_PYTHON_M2R_DEPENDENCIES = host-python-docutils host-python-mistune

$(eval $(python-package))
$(eval $(host-python-package))
