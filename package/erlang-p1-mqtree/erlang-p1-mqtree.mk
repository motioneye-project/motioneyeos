################################################################################
#
# erlang-p1-mqtree
#
################################################################################

ERLANG_P1_MQTREE_VERSION = 1.0.5
ERLANG_P1_MQTREE_SITE = $(call github,processone,mqtree,$(ERLANG_P1_MQTREE_VERSION))
ERLANG_P1_MQTREE_LICENSE = Apache-2.0
ERLANG_P1_MQTREE_LICENSE_FILES = LICENSE
ERLANG_P1_MQTREE_DEPENDENCIES = erlang-p1-utils

$(eval $(rebar-package))
