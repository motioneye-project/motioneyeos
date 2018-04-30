################################################################################
#
# python-influxdb
#
################################################################################

PYTHON_INFLUXDB_VERSION = 5.0.0
PYTHON_INFLUXDB_SOURCE = influxdb-$(PYTHON_INFLUXDB_VERSION).tar.gz
PYTHON_INFLUXDB_SITE = https://files.pythonhosted.org/packages/95/26/33e7b85b72a0df2dc00af4c1b9f5df3e7d0aea29ae4f8f65a83f7024c4e2
PYTHON_INFLUXDB_SETUP_TYPE = setuptools
PYTHON_INFLUXDB_LICENSE = MIT
PYTHON_INFLUXDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
