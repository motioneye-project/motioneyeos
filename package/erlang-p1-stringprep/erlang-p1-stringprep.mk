################################################################################
#
# erlang-p1-stringprep
#
################################################################################

ERLANG_P1_STRINGPREP_VERSION = 1.0.0
ERLANG_P1_STRINGPREP_SITE = $(call github,processone,stringprep,$(ERLANG_P1_STRINGPREP_VERSION))
ERLANG_P1_STRINGPREP_LICENSE = TCL (tools/*.tcl), Apache-2.0 (rest)
ERLANG_P1_STRINGPREP_LICENSE_FILES = LICENSE.ALL LICENSE.TCL LICENSE.txt
ERLANG_P1_STRINGPREP_DEPENDENCIES = erlang-p1-utils

$(eval $(rebar-package))
