################################################################################
#
# python-parso
#
################################################################################

PYTHON_PARSO_VERSION = 0.4.0
PYTHON_PARSO_SOURCE = parso-$(PYTHON_PARSO_VERSION).tar.gz
PYTHON_PARSO_SITE = https://files.pythonhosted.org/packages/79/52/70d0bb8a1f4b1475a603b4b1484bb351edda30846996fc93fe1976948fef
PYTHON_PARSO_SETUP_TYPE = setuptools
PYTHON_PARSO_LICENSE = MIT, Python-2.0, BSD-3-Clause (flask theme)
PYTHON_PARSO_LICENSE_FILES = LICENSE.txt docs/_themes/flask/LICENSE test/normalizer_issue_files/LICENSE

$(eval $(python-package))
