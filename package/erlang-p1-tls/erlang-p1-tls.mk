################################################################################
#
# erlang-p1-tls
#
################################################################################

ERLANG_P1_TLS_VERSION = 1.0.0
ERLANG_P1_TLS_SITE = $(call github,processone,tls,$(ERLANG_P1_TLS_VERSION))
ERLANG_P1_TLS_LICENSE = GPL-2.0+ with OpenSSL exception
ERLANG_P1_TLS_LICENSE_FILES = COPYING
ERLANG_P1_TLS_INSTALL_STAGING = YES
ERLANG_P1_TLS_DEPENDENCIES = openssl

$(eval $(rebar-package))
