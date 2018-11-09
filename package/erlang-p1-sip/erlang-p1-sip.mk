################################################################################
#
# erlang-p1-sip
#
################################################################################

ERLANG_P1_SIP_VERSION = 1.0.17
ERLANG_P1_SIP_SITE = $(call github,processone,esip,$(ERLANG_P1_SIP_VERSION))
ERLANG_P1_SIP_LICENSE = Apache-2.0
ERLANG_P1_SIP_LICENSE_FILES = LICENSE.txt
ERLANG_P1_SIP_DEPENDENCIES = erlang-p1-stun erlang-p1-tls erlang-p1-utils
ERLANG_P1_SIP_INSTALL_STAGING = YES

$(eval $(rebar-package))
