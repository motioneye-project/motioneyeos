################################################################################
#
# erlang-p1-xml
#
################################################################################

ERLANG_P1_XML_VERSION = b530983
ERLANG_P1_XML_SITE = $(call github,processone,xml,$(ERLANG_P1_XML_VERSION))
ERLANG_P1_XML_LICENSE = GPLv2+
ERLANG_P1_XML_LICENSE_FILES = COPYING
ERLANG_P1_XML_DEPENDENCIES = expat
ERLANG_P1_XML_INSTALL_STAGING = YES

ERLANG_P1_XML_USE_AUTOCONF = YES

$(eval $(rebar-package))
