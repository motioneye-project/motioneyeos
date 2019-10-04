################################################################################
#
# python-influxdb
#
################################################################################

PYTHON_INFLUXDB_VERSION = 5.2.3
PYTHON_INFLUXDB_SOURCE = influxdb-$(PYTHON_INFLUXDB_VERSION).tar.gz
PYTHON_INFLUXDB_SITE = https://files.pythonhosted.org/packages/d2/0d/351a346886ecbe61211cbfcad8ac73f99f5a9bf526916631c5668dbad601
PYTHON_INFLUXDB_SETUP_TYPE = setuptools
PYTHON_INFLUXDB_LICENSE = MIT
PYTHON_INFLUXDB_LICENSE_FILES = LICENSE

$(eval $(python-package))
