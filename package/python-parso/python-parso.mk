################################################################################
#
# python-parso
#
################################################################################

PYTHON_PARSO_VERSION = 0.5.1
PYTHON_PARSO_SOURCE = parso-$(PYTHON_PARSO_VERSION).tar.gz
PYTHON_PARSO_SITE = https://files.pythonhosted.org/packages/21/40/615957db4d178b7504c87b1a5b85fa5945b0b4fa5f5a845e31fc7aad6018
PYTHON_PARSO_SETUP_TYPE = setuptools
PYTHON_PARSO_LICENSE = MIT, Python-2.0, BSD-3-Clause (flask theme)
PYTHON_PARSO_LICENSE_FILES = LICENSE.txt docs/_themes/flask/LICENSE test/normalizer_issue_files/LICENSE

$(eval $(python-package))
