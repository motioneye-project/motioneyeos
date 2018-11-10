################################################################################
#
# python-pytz
#
################################################################################

PYTHON_PYTZ_VERSION = 2017.3
PYTHON_PYTZ_SOURCE = pytz-$(PYTHON_PYTZ_VERSION).zip
PYTHON_PYTZ_SITE = https://pypi.python.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa
PYTHON_PYTZ_SETUP_TYPE = setuptools
PYTHON_PYTZ_LICENSE = MIT
PYTHON_PYTZ_LICENSE_FILES = LICENSE.txt

define PYTHON_PYTZ_EXTRACT_CMDS
	unzip $(DL_DIR)/$(PYTHON_PYTZ_SOURCE) -d $(@D)
	mv $(@D)/pytz-$(PYTHON_PYTZ_VERSION)/* $(@D)
	rmdir $(@D)/pytz-$(PYTHON_PYTZ_VERSION)
endef

$(eval $(python-package))
