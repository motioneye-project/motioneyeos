################################################################################
#
# python-influxdb
#
################################################################################

PYTHON_INFLUXDB_VERSION = 5.3.0
PYTHON_INFLUXDB_SOURCE = influxdb-$(PYTHON_INFLUXDB_VERSION).tar.gz
PYTHON_INFLUXDB_SITE = https://files.pythonhosted.org/packages/be/8d/85ec8f11299a6dfc115244db71fd8f13e9a69f5e9eb77dc3392f4f959e9a
PYTHON_INFLUXDB_SETUP_TYPE = setuptools
PYTHON_INFLUXDB_LICENSE = MIT
PYTHON_INFLUXDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
