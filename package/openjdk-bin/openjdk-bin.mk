################################################################################
#
# host-openjdk-bin
#
################################################################################

ifeq ($(BR2_OPENJDK_VERSION_LATEST),y)
HOST_OPENJDK_BIN_VERSION_MAJOR = 14.0.1
HOST_OPENJDK_BIN_VERSION_MINOR = 7
HOST_OPENJDK_BIN_VERSION = $(HOST_OPENJDK_BIN_VERSION_MAJOR)_$(HOST_OPENJDK_BIN_VERSION_MINOR)
HOST_OPENJDK_BIN_SOURCE = OpenJDK14U-jdk_x64_linux_hotspot_$(HOST_OPENJDK_BIN_VERSION).tar.gz
HOST_OPENJDK_BIN_SITE = https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-$(HOST_OPENJDK_BIN_VERSION_MAJOR)%2B$(HOST_OPENJDK_BIN_VERSION_MINOR)
else
HOST_OPENJDK_BIN_VERSION_MAJOR = 11.0.7
HOST_OPENJDK_BIN_VERSION_MINOR = 10
HOST_OPENJDK_BIN_VERSION = $(HOST_OPENJDK_BIN_VERSION_MAJOR)_$(HOST_OPENJDK_BIN_VERSION_MINOR)
HOST_OPENJDK_BIN_SOURCE = OpenJDK11U-jdk_x64_linux_hotspot_$(HOST_OPENJDK_BIN_VERSION).tar.gz
HOST_OPENJDK_BIN_SITE = https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-$(HOST_OPENJDK_BIN_VERSION_MAJOR)%2B$(HOST_OPENJDK_BIN_VERSION_MINOR)
endif
HOST_OPENJDK_BIN_LICENSE = GPL-2.0+ with exception
HOST_OPENJDK_BIN_LICENSE_FILES = legal/java.prefs/LICENSE legal/java.prefs/ASSEMBLY_EXCEPTION

HOST_OPENJDK_BIN_ROOT_DIR = $(HOST_DIR)/usr/lib/jvm

# unpack200 has an invalid RPATH and relies on libzlib. When
# host-libzlib is installed on the system, the error "ERROR: package
# host-libzlib installs executables without proper RPATH: will occur.
# Because unpack200 is a deprecated tool, removing it to fix this
# issue is safe.
define HOST_OPENJDK_BIN_INSTALL_CMDS
	mkdir -p $(HOST_OPENJDK_BIN_ROOT_DIR)
	cp -dpfr $(@D)/* $(HOST_OPENJDK_BIN_ROOT_DIR)
	$(RM) -f $(HOST_OPENJDK_BIN_ROOT_DIR)/bin/unpack200
endef

$(eval $(host-generic-package))

# variables used by other packages
JAVAC = $(HOST_OPENJDK_BIN_ROOT_DIR)/bin/javac
