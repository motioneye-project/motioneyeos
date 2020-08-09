################################################################################
#
# erlang-jose
#
################################################################################

ERLANG_JOSE_VERSION = 1.9.0
ERLANG_JOSE_SITE = $(call github,potatosalad,erlang-jose,$(ERLANG_JOSE_VERSION))
ERLANG_JOSE_LICENSE = MIT
ERLANG_JOSE_LICENSE_FILES = LICENSE.md
ERLANG_JOSE_DEPENDENCIES = erlang-base64url

$(eval $(rebar-package))
