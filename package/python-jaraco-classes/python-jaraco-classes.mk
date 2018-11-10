################################################################################
#
# python-jaraco-classes
#
################################################################################

PYTHON_JARACO_CLASSES_VERSION = 1.4.3
PYTHON_JARACO_CLASSES_SOURCE = jaraco.classes-$(PYTHON_JARACO_CLASSES_VERSION).tar.gz
PYTHON_JARACO_CLASSES_SITE = https://pypi.python.org/packages/b3/ce/031a6004619c2a3744b977b4a8414d7e8087afe6247110efcac797fee7f1
PYTHON_JARACO_CLASSES_LICENSE = MIT
PYTHON_JARACO_CLASSES_LICENSE_FILES = LICENSE
PYTHON_JARACO_CLASSES_SETUP_TYPE = setuptools
PYTHON_JARACO_CLASSES_DEPENDENCIES = host-python-setuptools-scm

$(eval $(python-package))
