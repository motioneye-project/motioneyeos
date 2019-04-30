################################################################################
#
# python-jinja2
#
################################################################################

PYTHON_JINJA2_VERSION = 2.10.1
PYTHON_JINJA2_SOURCE = Jinja2-$(PYTHON_JINJA2_VERSION).tar.gz
PYTHON_JINJA2_SITE = https://files.pythonhosted.org/packages/93/ea/d884a06f8c7f9b7afbc8138b762e80479fb17aedbbe2b06515a12de9378d
PYTHON_JINJA2_SETUP_TYPE = setuptools
PYTHON_JINJA2_LICENSE = BSD-3-Clause
PYTHON_JINJA2_LICENSE_FILES = LICENSE

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
