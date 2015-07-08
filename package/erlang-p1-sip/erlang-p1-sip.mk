################################################################################
#
# erlang-p1-sip
#
################################################################################

ERLANG_P1_SIP_VERSION = fd3e461
ERLANG_P1_SIP_SITE = $(call github,processone,p1_sip,$(ERLANG_P1_SIP_VERSION))
ERLANG_P1_SIP_LICENSE = GPLv2 with OpenSSL exception
ERLANG_P1_SIP_LICENSE_FILES = COPYING
ERLANG_P1_SIP_DEPENDENCIES = erlang-p1-stun erlang-p1-tls erlang-p1-utils
ERLANG_P1_SIP_INSTALL_STAGING = YES

$(eval $(rebar-package))
