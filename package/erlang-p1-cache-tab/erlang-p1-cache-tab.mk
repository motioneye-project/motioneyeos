################################################################################
#
# erlang-p1-cache-tab
#
################################################################################

ERLANG_P1_CACHE_TAB_VERSION = 7b89d6a
ERLANG_P1_CACHE_TAB_SITE = $(call github,processone,cache_tab,$(ERLANG_P1_CACHE_TAB_VERSION))
ERLANG_P1_CACHE_TAB_LICENSE = GPLv2+
ERLANG_P1_CACHE_TAB_LICENSE_FILES = COPYING
ERLANG_P1_CACHE_TAB_DEPENDENCIES = erlang-p1-utils

$(eval $(rebar-package))
