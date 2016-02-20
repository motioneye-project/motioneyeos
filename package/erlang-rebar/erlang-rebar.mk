################################################################################
#
# erlang-rebar
#
################################################################################

ERLANG_REBAR_VERSION = 2.5.1

# Upstream publishes a release, but we can not use it as it is a release of
# a generated rebar script, when we want the sources. So we have to use the
# gihub helper in this case.
ERLANG_REBAR_SITE = $(call github,rebar,rebar,$(ERLANG_REBAR_VERSION))

# Although the file LICENSE state Apache-2.0, a lot (if not all) the files
# in src/ bear the MIT licence.
ERLANG_REBAR_LICENSE = Apache-2.0, MIT
ERLANG_REBAR_LICENSE_FILES = LICENSE

# We do not have a target variant, so just define the dependencies,
# configure and build commands for the host variant.
HOST_ERLANG_REBAR_DEPENDENCIES = host-erlang

define HOST_ERLANG_REBAR_BUILD_CMDS
	cd $(@D) && $(HOST_MAKE_ENV) $(MAKE)
endef

define HOST_ERLANG_REBAR_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/rebar $(HOST_DIR)/usr/bin/rebar
endef

$(eval $(host-generic-package))
