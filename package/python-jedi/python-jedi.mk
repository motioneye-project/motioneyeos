################################################################################
#
# python-jedi
#
################################################################################

PYTHON_JEDI_VERSION = 0.17.0
PYTHON_JEDI_SOURCE = jedi-$(PYTHON_JEDI_VERSION).tar.gz
PYTHON_JEDI_SITE = https://files.pythonhosted.org/packages/e3/5b/65ff9c102d92bf719dfaeff57bc8074d68f26ea480005704a956da995799
PYTHON_JEDI_SETUP_TYPE = setuptools
PYTHON_JEDI_LICENSE = MIT, Apache-2.0 (typeshed)
PYTHON_JEDI_LICENSE_FILES = LICENSE.txt jedi/third_party/typeshed/LICENSE

$(eval $(python-package))
