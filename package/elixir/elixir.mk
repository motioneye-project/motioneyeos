################################################################################
#
# elixir
#
################################################################################

ELIXIR_VERSION = 1.9.4
ELIXIR_SITE = $(call github,elixir-lang,elixir,v$(ELIXIR_VERSION))
ELIXIR_LICENSE = Apache-2.0
ELIXIR_LICENSE_FILES = LICENSE
ELIXIR_DEPENDENCIES = host-erlang

define HOST_ELIXIR_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) compile
endef

define HOST_ELIXIR_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) PREFIX="$(HOST_DIR)" -C $(@D) install
endef

$(eval $(host-generic-package))
