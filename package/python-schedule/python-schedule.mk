################################################################################
#
# python-schedule
#
################################################################################

PYTHON_SCHEDULE_VERSION = 0.5.0
PYTHON_SCHEDULE_SOURCE = schedule-$(PYTHON_SCHEDULE_VERSION).tar.gz
PYTHON_SCHEDULE_SITE = https://pypi.python.org/packages/fd/31/599a3387c2e98c270d5ac21a1575f3eb60a3712c192a0ca97a494a207739
PYTHON_SCHEDULE_SETUP_TYPE = setuptools
PYTHON_SCHEDULE_LICENSE = MIT
PYTHON_SCHEDULE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
