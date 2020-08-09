################################################################################
#
# erlang-p1-tls
#
################################################################################

ERLANG_P1_TLS_VERSION = 1.1.2
ERLANG_P1_TLS_SITE = $(call github,processone,fast_tls,$(ERLANG_P1_TLS_VERSION))
ERLANG_P1_TLS_LICENSE = Apache-2.0
ERLANG_P1_TLS_LICENSE_FILES = LICENSE.txt
ERLANG_P1_TLS_INSTALL_STAGING = YES
ERLANG_P1_TLS_DEPENDENCIES = openssl erlang-p1-utils

$(eval $(rebar-package))
