################################################################################
#
# erlang-p1-cache-tab
#
################################################################################

ERLANG_P1_CACHE_TAB_VERSION = 1.0.12
ERLANG_P1_CACHE_TAB_SITE = $(call github,processone,cache_tab,$(ERLANG_P1_CACHE_TAB_VERSION))
ERLANG_P1_CACHE_TAB_LICENSE = Apache-2.0
ERLANG_P1_CACHE_TAB_LICENSE_FILES = LICENSE.txt
ERLANG_P1_CACHE_TAB_DEPENDENCIES = erlang-p1-utils

$(eval $(rebar-package))
