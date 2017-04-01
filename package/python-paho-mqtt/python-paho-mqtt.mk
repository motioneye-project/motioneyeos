################################################################################
#
# python-paho-mqtt
#
################################################################################

PYTHON_PAHO_MQTT_VERSION = 1.2
PYTHON_PAHO_MQTT_SOURCE = paho-mqtt-$(PYTHON_PAHO_MQTT_VERSION).tar.gz
PYTHON_PAHO_MQTT_SITE = https://pypi.python.org/packages/82/d9/7064d3a0a1d62756a1a809c85b99f864c641b66de84c15458f72193b7708
PYTHON_PAHO_MQTT_LICENSE = EPL-1.0 or EDLv1.0
PYTHON_PAHO_MQTT_LICENSE_FILES = LICENSE.txt edl-v10 epl-v10
PYTHON_PAHO_MQTT_SETUP_TYPE = distutils

$(eval $(python-package))
