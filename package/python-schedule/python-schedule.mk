################################################################################
#
# python-schedule
#
################################################################################

PYTHON_SCHEDULE_VERSION = 0.6.0
PYTHON_SCHEDULE_SOURCE = schedule-$(PYTHON_SCHEDULE_VERSION).tar.gz
PYTHON_SCHEDULE_SITE = https://files.pythonhosted.org/packages/00/07/6a9953ff83e003eaadebf0a51d33c6b596f9451fcbea36a3a2e575f6af99
PYTHON_SCHEDULE_SETUP_TYPE = setuptools
PYTHON_SCHEDULE_LICENSE = MIT
PYTHON_SCHEDULE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
