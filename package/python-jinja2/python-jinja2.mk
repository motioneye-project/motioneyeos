################################################################################
#
# python-jinja2
#
################################################################################

PYTHON_JINJA2_VERSION = 2.10.3
PYTHON_JINJA2_SOURCE = Jinja2-$(PYTHON_JINJA2_VERSION).tar.gz
PYTHON_JINJA2_SITE = https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799
PYTHON_JINJA2_SETUP_TYPE = setuptools
PYTHON_JINJA2_LICENSE = BSD-3-Clause
PYTHON_JINJA2_LICENSE_FILES = LICENSE.rst

# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON_JINJA2_DEPENDENCIES = host-python-markupsafe

# Both asyncsupport.py and asyncfilters.py use async feature, that is
# not available in Python 2 and some features available in Python 3.6.
# So in both cases *.py compilation would produce compiler errors.
# Hence remove both files after package extraction.
ifeq ($(BR2_PACKAGE_PYTHON),y)
define PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT
	rm $(@D)/jinja2/asyncsupport.py $(@D)/jinja2/asyncfilters.py
endef

PYTHON_JINJA2_POST_EXTRACT_HOOKS = PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT
endif

$(eval $(python-package))
$(eval $(host-python-package))
