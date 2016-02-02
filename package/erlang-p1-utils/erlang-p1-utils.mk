################################################################################
#
# erlang-p1-utils
#
################################################################################

ERLANG_P1_UTILS_VERSION = 1.0.3
ERLANG_P1_UTILS_SITE = $(call github,processone,p1_utils,$(ERLANG_P1_UTILS_VERSION))
ERLANG_P1_UTILS_LICENSE = GPLv2+
ERLANG_P1_UTILS_LICENSE_FILES = LICENSE.txt
ERLANG_P1_UTILS_INSTALL_STAGING = YES

$(eval $(rebar-package))
