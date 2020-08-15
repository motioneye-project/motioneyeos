################################################################################
#
# erlang-base64url
#
################################################################################

ERLANG_BASE64URL_VERSION = 1.0.1
ERLANG_BASE64URL_SITE = $(call github,dvv,base64url,$(ERLANG_BASE64URL_VERSION))
ERLANG_BASE64URL_LICENSE = MIT
ERLANG_BASE64URL_LICENSE_FILES = LICENSE.txt

$(eval $(rebar-package))
