################################################################################
#
# python-paho-mqtt
#
################################################################################

PYTHON_PAHO_MQTT_VERSION = 1.1
PYTHON_PAHO_MQTT_SOURCE = paho-mqtt-$(PYTHON_PAHO_MQTT_VERSION).tar.gz
PYTHON_PAHO_MQTT_SITE = https://pypi.python.org/packages/source/p/paho-mqtt
PYTHON_PAHO_MQTT_LICENSE = EPLv1.0 or EDLv1.0
PYTHON_PAHO_MQTT_LICENSE_FILES = LICENSE.txt edl-v10 epl-v10
PYTHON_PAHO_MQTT_SETUP_TYPE = distutils

$(eval $(python-package))
