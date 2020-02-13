################################################################################
#
# rabbitmq-server
#
################################################################################

RABBITMQ_SERVER_VERSION = 3.8.2
RABBITMQ_SERVER_SITE = https://github.com/rabbitmq/rabbitmq-server/releases/download/v$(RABBITMQ_SERVER_VERSION)
RABBITMQ_SERVER_SOURCE = rabbitmq-server-$(RABBITMQ_SERVER_VERSION).tar.xz
RABBITMQ_SERVER_LICENSE = MPL-1.1, Apache-2.0, BSD-3-Clause, BSD-2-Clause, MIT, MPL-2.0, ISC
RABBITMQ_SERVER_LICENSE_FILES = \
	LICENSE \
	LICENSE-APACHE2 \
	LICENSE-APACHE2-excanvas \
	LICENSE-APACHE2-ExplorerCanvas \
	LICENSE-APL2-Stomp-Websocket \
	LICENSE-BSD-base64js \
	LICENSE-BSD-recon \
	LICENSE-erlcloud \
	LICENSE-httpc_aws \
	LICENSE-ISC-cowboy \
	LICENSE-MIT-EJS \
	LICENSE-MIT-EJS10 \
	LICENSE-MIT-Erlware-Commons \
	LICENSE-MIT-Flot \
	LICENSE-MIT-jQuery \
	LICENSE-MIT-jQuery164 \
	LICENSE-MIT-Mochi \
	LICENSE-MIT-Sammy \
	LICENSE-MIT-Sammy060 \
	LICENSE-MPL \
	LICENSE-MPL-RabbitMQ \
	LICENSE-MPL2 \
	LICENSE-rabbitmq_aws

RABBITMQ_SERVER_DEPENDENCIES = host-elixir host-libxslt host-zip erlang libxslt
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
endef

define RABBITMQ_SERVER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/rabbitmq-server/S50rabbitmq-server \
		$(TARGET_DIR)/etc/init.d/S50rabbitmq-server
endef

define RABBITMQ_SERVER_USERS
	rabbitmq -1 rabbitmq -1 * /var/lib/rabbitmq /bin/sh - rabbitmq-server daemon
endef

$(eval $(generic-package))
