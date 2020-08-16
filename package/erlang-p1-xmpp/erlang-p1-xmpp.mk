################################################################################
#
# erlang-p1-xmpp
#
################################################################################

ERLANG_P1_XMPP_VERSION = 1.4.2
ERLANG_P1_XMPP_SITE = $(call github,processone,xmpp,$(ERLANG_P1_XMPP_VERSION))
ERLANG_P1_XMPP_LICENSE = Apache-2.0
ERLANG_P1_XMPP_LICENSE_FILES = LICENSE.txt
ERLANG_P1_XMPP_INSTALL_STAGING = YES
ERLANG_P1_XMPP_DEPENDENCIES = erlang-p1-xml erlang-p1-stringprep \
	erlang-p1-tls erlang-p1-utils erlang-p1-zlib host-erlang-p1-xml
HOST_ERLANG_P1_XMPP_DEPENDENCIES = host-erlang-p1-xml

$(eval $(rebar-package))
$(eval $(host-rebar-package))
