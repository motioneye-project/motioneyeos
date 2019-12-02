################################################################################
#
# paho-mqtt-cpp
#
################################################################################

PAHO_MQTT_CPP_VERSION = 1.1
PAHO_MQTT_CPP_SITE = $(call github,eclipse,paho.mqtt.cpp,v$(PAHO_MQTT_CPP_VERSION))
PAHO_MQTT_CPP_LICENSE = EPL-1.0 or BSD-3-Clause
PAHO_MQTT_CPP_LICENSE_FILES = epl-v10 edl-v10
PAHO_MQTT_CPP_INSTALL_STAGING = YES
PAHO_MQTT_CPP_DEPENDENCIES = paho-mqtt-c

# The following CMake variable disables a TRY_RUN call in the -pthread
# test which is not allowed when cross-compiling (for cmake < 3.10)
PAHO_MQTT_CPP_CONF_OPTS = -DTHREADS_PTHREAD_ARG=OFF

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PAHO_MQTT_CPP_DEPENDENCIES += openssl
PAHO_MQTT_CPP_CONF_OPTS += -DPAHO_WITH_SSL=TRUE
else
PAHO_MQTT_CPP_CONF_OPTS += -DPAHO_WITH_SSL=FALSE
endif

$(eval $(cmake-package))
