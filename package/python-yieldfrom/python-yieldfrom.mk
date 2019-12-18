################################################################################
#
# python-yieldfrom
#
################################################################################

PYTHON_YIELDFROM_VERSION = 1.0.5
PYTHON_YIELDFROM_SOURCE = yieldfrom-$(PYTHON_YIELDFROM_VERSION).tar.gz
PYTHON_YIELDFROM_SITE = https://files.pythonhosted.org/packages/4d/f9/395917f574ace618eb234bcbae8df3fabaa9624532d96d1fbd3a20678b1e
PYTHON_YIELDFROM_SETUP_TYPE = setuptools
PYTHON_YIELDFROM_LICENSE = MIT
PYTHON_YIELDFROM_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
