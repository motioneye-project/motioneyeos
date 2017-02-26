################################################################################
#
# python-functools32
#
################################################################################

PYTHON_FUNCTOOLS32_VERSION = 3.2.3-2
PYTHON_FUNCTOOLS32_SOURCE = functools32-$(PYTHON_FUNCTOOLS32_VERSION).tar.gz
PYTHON_FUNCTOOLS32_SITE = https://pypi.python.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db
PYTHON_FUNCTOOLS32_SETUP_TYPE = distutils

$(eval $(python-package))

