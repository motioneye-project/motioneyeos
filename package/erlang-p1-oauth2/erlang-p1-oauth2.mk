################################################################################
#
# erlang-p1-oauth2
#
################################################################################

ERLANG_P1_OAUTH2_VERSION = 0.6.1
ERLANG_P1_OAUTH2_SITE = $(call github,processone,p1_oauth2,$(ERLANG_P1_OAUTH2_VERSION))
ERLANG_P1_OAUTH2_LICENSE = MIT
ERLANG_P1_OAUTH2_LICENSE_FILES = LICENSE
ERLANG_P1_OAUTH2_INSTALL_STAGING = YES

$(eval $(rebar-package))
