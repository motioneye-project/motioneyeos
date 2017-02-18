################################################################################
#
# erlang-lager
#
################################################################################

ERLANG_LAGER_VERSION = 2.2.0
ERLANG_LAGER_SITE = $(call github,basho,lager,$(ERLANG_LAGER_VERSION))
ERLANG_LAGER_LICENSE = Apache-2.0
ERLANG_LAGER_LICENSE_FILES = LICENSE
ERLANG_LAGER_DEPENDENCIES = erlang-goldrush

$(eval $(rebar-package))
$(eval $(host-rebar-package))
