################################################################################
#
# python-jedi
#
################################################################################

PYTHON_JEDI_VERSION = 0.15.1
PYTHON_JEDI_SOURCE = jedi-$(PYTHON_JEDI_VERSION).tar.gz
PYTHON_JEDI_SITE = https://files.pythonhosted.org/packages/85/03/cd5a6e44a5753b4d539288d9d1f9645caac889c17dd2950292a8818f86b2
PYTHON_JEDI_SETUP_TYPE = setuptools
PYTHON_JEDI_LICENSE = MIT, BSD-3-Clause (flask theme), Apache-2.0 (typeshed)
PYTHON_JEDI_LICENSE_FILES = \
	LICENSE.txt docs/_themes/flask/LICENSE jedi/third_party/typeshed/LICENSE

$(eval $(python-package))
