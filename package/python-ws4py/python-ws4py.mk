################################################################################
#
# python-ws4py
#
################################################################################

PYTHON_WS4PY_VERSION = 0.5.1
PYTHON_WS4PY_SOURCE = ws4py-$(PYTHON_WS4PY_VERSION).tar.gz
PYTHON_WS4PY_SITE = https://files.pythonhosted.org/packages/53/20/4019a739b2eefe9282d3822ef6a225250af964b117356971bd55e274193c
PYTHON_WS4PY_SETUP_TYPE = setuptools
PYTHON_WS4PY_LICENSE = BSD-3-Clause
PYTHON_WS4PY_LICENSE_FILES = LICENSE

$(eval $(python-package))
