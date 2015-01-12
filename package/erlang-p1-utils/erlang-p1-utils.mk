################################################################################
#
# erlang-p1-utils
#
################################################################################

ERLANG_P1_UTILS_VERSION = 940f42d
ERLANG_P1_UTILS_SITE = $(call github,processone,p1_utils,$(ERLANG_P1_UTILS_VERSION))
ERLANG_P1_UTILS_LICENSE = GPLv2+
ERLANG_P1_UTILS_LICENSE_FILES = COPYING
ERLANG_P1_UTILS_INSTALL_STAGING = YES

$(eval $(rebar-package))
