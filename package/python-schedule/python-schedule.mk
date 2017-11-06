################################################################################
#
# python-schedule
#
################################################################################

PYTHON_SCHEDULE_VERSION = 0.4.3
PYTHON_SCHEDULE_SOURCE = schedule-$(PYTHON_SCHEDULE_VERSION).tar.gz
PYTHON_SCHEDULE_SITE = https://pypi.python.org/packages/ee/68/ba6b0bb69b2be13b32983971bca6c5adf22df6321945232e1419bc34a82f
PYTHON_SCHEDULE_SETUP_TYPE = setuptools
PYTHON_SCHEDULE_LICENSE = MIT
PYTHON_SCHEDULE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
