#############################################################
#
# rabbitmq-server
#
#############################################################

RABBITMQ_SERVER_VERSION = 3.6.6
RABBITMQ_SERVER_SITE = http://www.rabbitmq.com/releases/rabbitmq-server/v$(RABBITMQ_SERVER_VERSION)
RABBITMQ_SERVER_SOURCE = rabbitmq-server-$(RABBITMQ_SERVER_VERSION).tar.xz
RABBITMQ_SERVER_LICENSE = MPLv1.1, Apache-2.0, BSD-2c, EPL, MIT, MPLv2.0
RABBITMQ_SERVER_LICENSE_FILES = LICENSE-MPL-RabbitMQ \
				LICENSE LICENSE-APACHE2-ExplorerCanvas \
				LICENSE-APL2-Rebar LICENSE-APL2-Stomp-Websocket \
				LICENSE-BSD-base64js LICENSE-BSD-glMatrix \
				LICENSE-EPL-OTP LICENSE-MIT-EJS10 \
				LICENSE-MIT-Flot LICENSE-MIT-jQuery164 \
				LICENSE-MIT-Mochi LICENSE-MIT-Mochiweb \
				LICENSE-MIT-Sammy060 LICENSE-MIT-SockJS \
				LICENSE-MPL2
RABBITMQ_SERVER_DEPENDENCIES = host-libxslt host-zip erlang libxslt
RABBITMQ_SERVER_TARGET_BINS = rabbitmq-plugins rabbitmq-server rabbitmqctl rabbitmq-env rabbitmq-defaults

define RABBITMQ_SERVER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define RABBITMQ_SERVER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(@D) install

	for bin in $(RABBITMQ_SERVER_TARGET_BINS); do \
		ln -sf ../lib/erlang/lib/rabbitmq_server-$(RABBITMQ_SERVER_VERSION)/sbin/$$bin \
			$(TARGET_DIR)/usr/sbin/$$bin; \
	done
endef

define RABBITMQ_SERVER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/rabbitmq-server/rabbitmq-server.service \
		$(TARGET_DIR)/usr/lib/systemd/system/rabbitmq-server.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs ../../../../usr/lib/systemd/system/rabbitmq-server.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/rabbitmq-server.service
endef

define RABBITMQ_SERVER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/rabbitmq-server/S50rabbitmq-server \
		$(TARGET_DIR)/etc/init.d/S50rabbitmq-server
endef

define RABBITMQ_SERVER_USERS
	rabbitmq -1 rabbitmq -1 * /var/lib/rabbitmq /bin/sh - rabbitmq-server daemon
endef

$(eval $(generic-package))
