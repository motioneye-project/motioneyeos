################################################################################
#
# erlang-eimp
#
################################################################################

ERLANG_EIMP_VERSION = 1.0.12
ERLANG_EIMP_SITE = $(call github,processone,eimp,$(ERLANG_EIMP_VERSION))
ERLANG_EIMP_LICENSE = Apache-2.0
ERLANG_EIMP_LICENSE_FILES = LICENSE.txt
ERLANG_EIMP_DEPENDENCIES = erlang-p1-utils gd jpeg libpng webp

$(eval $(rebar-package))
