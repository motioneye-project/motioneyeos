################################################################################
#
# erlang-fast_tls
#
################################################################################

ERLANG_FAST_TLS_VERSION = 1.0.0
ERLANG_FAST_TLS_SITE = $(call github,processone,fast_tls,$(ERLANG_FAST_TLS_VERSION))
ERLANG_FAST_TLS_LICENSE = Apache-2.0
ERLANG_FAST_TLS_LICENSE_FILES = LICENSE.txt
ERLANG_FAST_TLS_INSTALL_STAGING = YES
ERLANG_FAST_TLS_DEPENDENCIES = openssl erlang-p1-utils

$(eval $(rebar-package))
