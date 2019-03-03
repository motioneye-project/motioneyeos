################################################################################
#
# python-terminaltables
#
################################################################################

PYTHON_TERMINALTABLES_VERSION = 3.1.0
PYTHON_TERMINALTABLES_SOURCE = terminaltables-$(PYTHON_TERMINALTABLES_VERSION).tar.gz
PYTHON_TERMINALTABLES_SITE = https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff
PYTHON_TERMINALTABLES_SETUP_TYPE = setuptools
PYTHON_TERMINALTABLES_LICENSE = MIT

$(eval $(python-package))
