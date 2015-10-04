################################################################################
#
# erlang-p1-tls
#
################################################################################

ERLANG_P1_TLS_VERSION = b070004
ERLANG_P1_TLS_SITE = $(call github,processone,tls,$(ERLANG_P1_TLS_VERSION))
ERLANG_P1_TLS_LICENSE = GPLv2+
ERLANG_P1_TLS_LICENSE_FILES = COPYING
ERLANG_P1_TLS_INSTALL_STAGING = YES

$(eval $(rebar-package))
