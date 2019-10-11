################################################################################
#
# python-h2
#
################################################################################

PYTHON_H2_VERSION = 3.1.1
PYTHON_H2_SOURCE = h2-$(PYTHON_H2_VERSION).tar.gz
PYTHON_H2_SITE = https://files.pythonhosted.org/packages/56/73/0bc3a2f4238bdfbd9b0dc41a972fb558d96e8580ef2a37129ee5a54fa04e
PYTHON_H2_SETUP_TYPE = setuptools
PYTHON_H2_LICENSE = MIT
PYTHON_H2_LICENSE_FILES = LICENSE

$(eval $(python-package))
