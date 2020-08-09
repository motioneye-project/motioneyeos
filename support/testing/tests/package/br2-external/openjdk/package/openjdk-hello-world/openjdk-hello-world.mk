################################################################################
#
# openjdk hello world
#
################################################################################

OPENJDK_HELLO_WORLD_DEPENDENCIES = openjdk

define OPENJDK_HELLO_WORLD_BUILD_CMDS
	$(INSTALL) -D $(OPENJDK_HELLO_WORLD_PKGDIR)/HelloWorld.java $(@D)/HelloWorld.java
	$(JAVAC) $(@D)/HelloWorld.java
endef

define OPENJDK_HELLO_WORLD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/HelloWorld.class $(TARGET_DIR)/usr/bin/HelloWorld.class
endef

$(eval $(generic-package))
