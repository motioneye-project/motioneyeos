################################################################################
#
# azure-iot-sdk-c
#
################################################################################

AZURE_IOT_SDK_C_VERSION = 2018-12-13
AZURE_IOT_SDK_C_SITE = https://github.com/Azure/azure-iot-sdk-c
AZURE_IOT_SDK_C_SITE_METHOD = git
AZURE_IOT_SDK_C_GIT_SUBMODULES = YES
AZURE_IOT_SDK_C_LICENSE = MIT
AZURE_IOT_SDK_C_LICENSE_FILES = LICENSE
AZURE_IOT_SDK_C_INSTALL_STAGING = YES
AZURE_IOT_SDK_C_DEPENDENCIES = libxml2 openssl libcurl util-linux
AZURE_IOT_SDK_C_CONF_OPTS = -Dskip_samples=ON

# The project only supports building one kind of library.
# Further the install target installs the wrong files, so we do it here:
ifeq ($(BR2_STATIC_LIBS),y)
AZURE_IOT_SDK_C_LIBS += \
	uamqp/libuamqp.a \
	c-utility/libaziotsharedutil.a \
	iothub_client/libiothub_client.a \
	iothub_client/libiothub_client_mqtt_ws_transport.a \
	iothub_client/libiothub_client_amqp_ws_transport.a \
	iothub_client/libiothub_client_http_transport.a \
	iothub_client/libiothub_client_amqp_transport.a \
	iothub_client/libiothub_client_mqtt_transport.a \
	iothub_service_client/libiothub_service_client.a \
	serializer/libserializer.a \
	umqtt/libumqtt.a \
	libparson.a
else
AZURE_IOT_SDK_C_LIBS += \
	uamqp/libuamqp.so \
	c-utility/libaziotsharedutil.so \
	iothub_client/libiothub_client.so \
	iothub_client/libiothub_client_mqtt_ws_transport.so \
	iothub_client/libiothub_client_amqp_ws_transport.so \
	iothub_client/libiothub_client_http_transport.so \
	iothub_client/libiothub_client_amqp_transport.so \
	iothub_client/libiothub_client_mqtt_transport.so \
	iothub_service_client/libiothub_service_client.so \
	serializer/libserializer.so \
	umqtt/libumqtt.so.1.1.11 \
	libparson.so

define AZURE_IOT_SDK_C_CREATE_SYMLINKS
	ln -sf libumqtt.so.1.1.11 $(1)/usr/lib/libumqtt.so.1
	ln -sf libumqtt.so.1.1.11 $(1)/usr/lib/libumqtt.so
endef
endif

define AZURE_IOT_SDK_C_INSTALL_LIBS
	$(foreach l,$(AZURE_IOT_SDK_C_LIBS), \
		$(INSTALL) -D -m 0755 $(@D)/$(l) $(1)/usr/lib/$(notdir $(l))
	)
	$(call AZURE_IOT_SDK_C_CREATE_SYMLINKS,$(1))
endef

define AZURE_IOT_SDK_C_INSTALL_STAGING_CMDS
	$(call AZURE_IOT_SDK_C_INSTALL_LIBS,$(STAGING_DIR))
	cp -a $(@D)/c-utility/inc/* $(STAGING_DIR)/usr/include/
	cp -a $(@D)/iothub_client/inc/* $(STAGING_DIR)/usr/include/
endef

define AZURE_IOT_SDK_C_INSTALL_TARGET_CMDS
	$(call AZURE_IOT_SDK_C_INSTALL_LIBS,$(TARGET_DIR))
endef

$(eval $(cmake-package))
