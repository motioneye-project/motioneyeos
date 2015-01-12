################################################################################
#
# erlang-p1-zlib
#
################################################################################

ERLANG_P1_ZLIB_VERSION = 52e82bb
ERLANG_P1_ZLIB_SITE = $(call github,processone,zlib,$(ERLANG_P1_ZLIB_VERSION))
ERLANG_P1_ZLIB_LICENSE = GPLv2+
ERLANG_P1_ZLIB_LICENSE_FILES = COPYING
ERLANG_P1_ZLIB_DEPENDENCIES = zlib

$(eval $(rebar-package))
