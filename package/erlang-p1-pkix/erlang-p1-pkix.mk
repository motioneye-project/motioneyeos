################################################################################
#
# erlang-p1-pkix
#
################################################################################

ERLANG_P1_PKIX_VERSION = 1.0.4
ERLANG_P1_PKIX_SITE = $(call github,processone,pkix,$(ERLANG_P1_PKIX_VERSION))
ERLANG_P1_PKIX_LICENSE = Apache-2.0
ERLANG_P1_PKIX_LICENSE_FILES = LICENSE

$(eval $(rebar-package))
