################################################################################
#
# erlang-jiffy
#
################################################################################

ERLANG_JIFFY_VERSION = 0.14.8
ERLANG_JIFFY_SITE = $(call github,davisp,jiffy,$(ERLANG_JIFFY_VERSION))
ERLANG_JIFFY_LICENSE = MIT (core), \
	BSD-3-Clause (Google double conversion library), \
	BSD-3-Clause (tests)
ERLANG_JIFFY_LICENSE_FILES = LICENSE

# Set version manually in jiffy.app.src otherwise "git describe" is used.
define ERLANG_JIFFY_SET_VERSION_HOOK
	$(SED) 's/{vsn, git}/{vsn, "$(ERLANG_JIFFY_VERSION)"}/' $(@D)/src/jiffy.app.src
endef
ERLANG_JIFFY_POST_PATCH_HOOKS = ERLANG_JIFFY_SET_VERSION_HOOK

$(eval $(rebar-package))
