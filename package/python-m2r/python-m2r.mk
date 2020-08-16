################################################################################
#
# python-m2r
#
################################################################################

PYTHON_M2R_VERSION = 0.2.1
PYTHON_M2R_SOURCE = m2r-$(PYTHON_M2R_VERSION).tar.gz
PYTHON_M2R_SITE = https://files.pythonhosted.org/packages/39/e7/9fae11a45f5e1a3a21d8a98d02948e597c4afd7848a0dbe1a1ebd235f13e
PYTHON_M2R_SETUP_TYPE = setuptools
PYTHON_M2R_LICENSE = MIT
PYTHON_M2R_LICENSE_FILES = LICENSE
HOST_PYTHON_M2R_DEPENDENCIES = host-python-docutils host-python-mistune

$(eval $(python-package))
$(eval $(host-python-package))
