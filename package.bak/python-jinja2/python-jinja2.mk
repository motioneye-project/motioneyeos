################################################################################
#
# python-jinja2
#
################################################################################

PYTHON_JINJA2_VERSION = 2.9.4
PYTHON_JINJA2_SOURCE = Jinja2-$(PYTHON_JINJA2_VERSION).tar.gz
PYTHON_JINJA2_SITE = https://pypi.python.org/packages/f4/3f/28387a5bbc6883082c16784c6135440b94f9d5938fb156ff579798e18eda
PYTHON_JINJA2_SETUP_TYPE = setuptools
PYTHON_JINJA2_LICENSE = BSD-3c
PYTHON_JINJA2_LICENSE_FILES = LICENSE
# In host build, setup.py tries to download markupsafe if it is not installed
HOST_PYTHON_JINJA2_DEPENDENCIES = host-python-markupsafe

# Both asyncsupport.py and asyncfilters.py use async feature, that is
# not available in Python 2 and some features available in Python 3.6.
# So in both cases *.py compilation would produce compiler errors.
# Hence remove both files after package extraction.
define PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT
	rm $(@D)/jinja2/asyncsupport.py $(@D)/jinja2/asyncfilters.py
endef

PYTHON_JINJA2_POST_EXTRACT_HOOKS = PYTHON_JINJA2_REMOVE_ASYNC_SUPPORT

$(eval $(python-package))
$(eval $(host-python-package))
