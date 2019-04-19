################################################################################
#
# python-jedi
#
################################################################################

PYTHON_JEDI_VERSION = 0.13.3
PYTHON_JEDI_SOURCE = jedi-$(PYTHON_JEDI_VERSION).tar.gz
PYTHON_JEDI_SITE = https://files.pythonhosted.org/packages/96/fb/e99fc0442f8a0fa4bf5d34162c2d98131489017f661bf8a331857844b145
PYTHON_JEDI_SETUP_TYPE = setuptools
PYTHON_JEDI_LICENSE = MIT, BSD-3-Clause (flask theme)
PYTHON_JEDI_LICENSE_FILES = LICENSE.txt docs/_themes/flask/LICENSE

$(eval $(python-package))
