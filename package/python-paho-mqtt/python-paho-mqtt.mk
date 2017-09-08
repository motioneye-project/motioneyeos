################################################################################
#
# python-paho-mqtt
#
################################################################################

PYTHON_PAHO_MQTT_VERSION = 1.3.0
PYTHON_PAHO_MQTT_SOURCE = paho-mqtt-$(PYTHON_PAHO_MQTT_VERSION).tar.gz
PYTHON_PAHO_MQTT_SITE = https://pypi.python.org/packages/33/7f/3ce1ffebaa0343d509aac003800b305d821e89dac3c11666f92e12feca14
PYTHON_PAHO_MQTT_LICENSE = EPL-1.0 or EDLv1.0
PYTHON_PAHO_MQTT_LICENSE_FILES = LICENSE.txt edl-v10 epl-v10
PYTHON_PAHO_MQTT_SETUP_TYPE = setuptools

$(eval $(python-package))
