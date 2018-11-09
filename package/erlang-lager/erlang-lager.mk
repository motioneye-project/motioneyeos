################################################################################
#
# erlang-lager
#
################################################################################

ERLANG_LAGER_VERSION = 3.4.2
ERLANG_LAGER_SITE = $(call github,erlang-lager,lager,$(ERLANG_LAGER_VERSION))
ERLANG_LAGER_LICENSE = Apache-2.0
ERLANG_LAGER_LICENSE_FILES = LICENSE
ERLANG_LAGER_DEPENDENCIES = erlang-goldrush
HOST_ERLANG_LAGER_DEPENDENCIES = host-erlang-goldrush

$(eval $(rebar-package))
$(eval $(host-rebar-package))
