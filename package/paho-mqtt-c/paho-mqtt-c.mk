################################################################################
#
# paho-mqtt-c
#
################################################################################

PAHO_MQTT_C_VERSION = v1.1.0
PAHO_MQTT_C_SITE = $(call github,eclipse,paho.mqtt.c,$(PAHO_MQTT_C_VERSION))
PAHO_MQTT_C_LICENSE = EPL-1.0 or BSD-3c
PAHO_MQTT_C_LICENSE_FILES = epl-v10 edl-v10
PAHO_MQTT_C_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PAHO_MQTT_C_DEPENDENCIES += openssl
PAHO_MQTT_C_CONF_OPTS += -DPAHO_WITH_SSL=TRUE
else
PAHO_MQTT_C_CONF_OPTS += -DPAHO_WITH_SSL=FALSE
endif

$(eval $(cmake-package))
