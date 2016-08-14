################################################################################
#
# erlang-p1-zlib
#
################################################################################

ERLANG_P1_ZLIB_VERSION = 1.0.0
ERLANG_P1_ZLIB_SITE = $(call github,processone,zlib,$(ERLANG_P1_ZLIB_VERSION))
ERLANG_P1_ZLIB_LICENSE = GPLv2+
ERLANG_P1_ZLIB_LICENSE_FILES = COPYING
ERLANG_P1_ZLIB_DEPENDENCIES = zlib

$(eval $(rebar-package))
