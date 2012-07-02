CMAKE_VERSION = 2.8.5
CMAKE_SITE = http://www.cmake.org/files/v2.8/

define HOST_CMAKE_CONFIGURE_CMDS
 (cd $(@D); \
	LDFLAGS="$(HOST_LDFLAGS)" \
	CFLAGS="$(HOST_CFLAGS)" \
	./bootstrap --prefix=$(HOST_DIR)/usr --parallel=$(PARALLEL_JOBS) \
 )
endef

define HOST_CMAKE_BUILD_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_CMAKE_INSTALL_CMDS
 $(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
