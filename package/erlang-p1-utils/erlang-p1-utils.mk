################################################################################
#
# erlang-p1-utils
#
################################################################################

ERLANG_P1_UTILS_VERSION = 1.0.10
ERLANG_P1_UTILS_SITE = $(call github,processone,p1_utils,$(ERLANG_P1_UTILS_VERSION))
ERLANG_P1_UTILS_LICENSE = Apache-2.0
ERLANG_P1_UTILS_LICENSE_FILES = LICENSE.txt
ERLANG_P1_UTILS_INSTALL_STAGING = YES

$(eval $(rebar-package))
$(eval $(host-rebar-package))
