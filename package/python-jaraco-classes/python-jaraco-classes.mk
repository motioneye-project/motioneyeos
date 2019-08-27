################################################################################
#
# python-jaraco-classes
#
################################################################################

PYTHON_JARACO_CLASSES_VERSION = 2.0
PYTHON_JARACO_CLASSES_SOURCE = jaraco.classes-$(PYTHON_JARACO_CLASSES_VERSION).tar.gz
PYTHON_JARACO_CLASSES_SITE = https://files.pythonhosted.org/packages/6e/27/f6ce0863a6ce574922ffe70d63c40b9771aefb686cb595cf435d184f0ca3
PYTHON_JARACO_CLASSES_LICENSE = MIT
PYTHON_JARACO_CLASSES_LICENSE_FILES = LICENSE
PYTHON_JARACO_CLASSES_SETUP_TYPE = setuptools
PYTHON_JARACO_CLASSES_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
