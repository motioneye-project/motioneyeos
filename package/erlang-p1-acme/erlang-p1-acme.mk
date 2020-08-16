################################################################################
#
# erlang-p1-acme
#
################################################################################

ERLANG_P1_ACME_VERSION = 1.0.1
ERLANG_P1_ACME_SITE = $(call github,processone,p1_acme,$(ERLANG_P1_ACME_VERSION))
ERLANG_P1_ACME_LICENSE = Apache-2.0
ERLANG_P1_ACME_LICENSE_FILES = LICENSE.txt
ERLANG_P1_ACME_DEPENDENCIES = erlang-idna erlang-jiffy erlang-jose erlang-p1-yconf

$(eval $(rebar-package))
