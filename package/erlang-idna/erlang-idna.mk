################################################################################
#
# erlang-idna
#
################################################################################

ERLANG_IDNA_VERSION = 6.0.0
ERLANG_IDNA_SITE = $(call github,benoitc,erlang-idna,$(ERLANG_IDNA_VERSION))
ERLANG_IDNA_LICENSE = MIT
ERLANG_IDNA_LICENSE_FILES = LICENSE

$(eval $(rebar-package))
