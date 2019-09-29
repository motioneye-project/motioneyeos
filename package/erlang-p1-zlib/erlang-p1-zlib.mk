################################################################################
#
# erlang-p1-zlib
#
################################################################################

ERLANG_P1_ZLIB_VERSION = 1.0.4
ERLANG_P1_ZLIB_SITE = $(call github,processone,ezlib,$(ERLANG_P1_ZLIB_VERSION))
ERLANG_P1_ZLIB_LICENSE = Apache-2.0
ERLANG_P1_ZLIB_LICENSE_FILES = LICENSE.txt
ERLANG_P1_ZLIB_DEPENDENCIES = zlib

$(eval $(rebar-package))
