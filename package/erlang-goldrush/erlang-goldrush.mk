################################################################################
#
# erlang-goldrush
#
################################################################################

ERLANG_GOLDRUSH_VERSION = 0.1.8
ERLANG_GOLDRUSH_SITE = $(call github,DeadZen,goldrush,$(ERLANG_GOLDRUSH_VERSION))
ERLANG_GOLDRUSH_LICENSE = ISC
ERLANG_GOLDRUSH_LICENSE_FILES = LICENSE
ERLANG_GOLDRUSH_INSTALL_STAGING = YES

$(eval $(rebar-package))
$(eval $(host-rebar-package))
