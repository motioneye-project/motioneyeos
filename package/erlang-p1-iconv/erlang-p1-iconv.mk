################################################################################
#
# erlang-p1-iconv
#
################################################################################

ERLANG_P1_ICONV_VERSION = 1.0.4
ERLANG_P1_ICONV_SITE = $(call github,processone,iconv,$(ERLANG_P1_ICONV_VERSION))
ERLANG_P1_ICONV_LICENSE = Apache-2.0
ERLANG_P1_ICONV_LICENSE_FILES = LICENSE.txt
ERLANG_P1_ICONV_DEPENDENCIES = erlang-p1-utils

ifeq ($(BR2_PACKAGE_LIBICONV),y)
ERLANG_P1_ICONV_DEPENDENCIES += libiconv
endif

ERLANG_P1_ICONV_USE_AUTOCONF = YES

$(eval $(rebar-package))
